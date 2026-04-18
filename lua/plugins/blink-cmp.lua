
return {
	"saghen/blink.cmp",
	dependencies = { "nvim-mini/mini.snippets" },
	lazy = false,
	opts = function(_, opts)
		local function get_ms()
			return require("mini.snippets")
		end

		-- Same virt_text wiper — blink's expand bypasses config.expand.insert
		-- so we need it here too for the completion-triggered path
		local function clear_virt_text()
			vim.schedule(function()
				local ms = get_ms()
				local session = ms.session.get()
				if not session then return end
				local bufnr = vim.api.nvim_get_current_buf()
				local ns_id = session.ns_id
				for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })) do
					local id, row, col, d = mark[1], mark[2], mark[3], mark[4]
					if d.virt_text and #d.virt_text > 0 then
						vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, col, {
							id = id,
							virt_text = {},
							end_row = d.end_row,
							end_col = d.end_col,
							hl_group = d.hl_group,
						})
					end
				end
			end)
		end

		local function paren_context()
			local col = vim.fn.col(".")
			local line = vim.api.nvim_get_current_line()
			local rest = line:sub(col)
			local word_tail = rest:match("^[%w_%.]*") or ""
			local after = rest:sub(#word_tail + 1)
			local inside = after:match("^%((.-)%)")
			if inside == nil then
				return false, false
			end
			local has_args = inside:match("%S") ~= nil
			return has_args, not has_args
		end

		local function smart_accept(cmp)
			if not cmp.is_visible() then
				return false
			end
			local _, empty = paren_context()
			local ok = cmp.accept()
			if ok and empty then
				vim.schedule(function()
					local cur_line = vim.api.nvim_get_current_line()
					local fixed = cur_line:gsub("%)%(%)$", ")"):gsub("%)%(%)([^%w%(])", ")" .. "%1")
					local cursor = vim.api.nvim_win_get_cursor(0)
					if fixed ~= cur_line then
						vim.api.nvim_set_current_line(fixed)
						local max_col = math.max(0, #fixed - 1)
						if cursor[2] > max_col then
							cursor = { cursor[1], max_col }
							vim.api.nvim_win_set_cursor(0, cursor)
						end
					end
					local line = vim.api.nvim_get_current_line()
					local col = cursor[2]
					local rest = line:sub(col + 1)
					local open = rest:find("%(%)")
					if open then
						vim.api.nvim_win_set_cursor(0, { cursor[1], col + open })
					end
				end)
			end
			return ok
		end

		return vim.tbl_deep_extend("force", opts or {}, {
			enabled = function()
				return vim.b.blink_enabled ~= false and vim.bo.buftype ~= "prompt"
			end,
			snippets = {
				-- No preset: we handle expand/jump fully ourselves via mini.snippets
				expand = function(snippet)
					local col = vim.fn.col(".")
					local line = vim.api.nvim_get_current_line()
					local rest = line:sub(col)
					local word_tail = rest:match("^[%w_%.]*") or ""
					local after = rest:sub(#word_tail + 1)
					local inside = after:match("^%((.-)%)")

					local has_real_args = inside ~= nil and inside:match("%S") ~= nil
					local has_empty_paren = inside ~= nil and not inside:match("%S")

					local ms = get_ms()
					if has_real_args then
						local name = snippet:match("^([%w_%.]+)") or snippet
						local row, c = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_buf_set_text(0, row - 1, c, row - 1, c, { name })
						vim.api.nvim_win_set_cursor(0, { row, c + #name })
					elseif has_empty_paren then
						ms.default_insert({ body = snippet })
						clear_virt_text()
						vim.schedule(function()
							local cl = vim.api.nvim_get_current_line()
							local fixed = cl:gsub("%)%(%)$", ")"):gsub("%)%(%)([^%w%(])", function(ch)
								return ")" .. ch
							end)
							if fixed ~= cl then
								vim.api.nvim_set_current_line(fixed)
							end
						end)
					else
						ms.default_insert({ body = snippet })
						clear_virt_text()
					end
				end,
			},
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				ghost_text = { enabled = false },
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
				},
				accept = {
					auto_brackets = { enabled = true },
					resolve_timeout_ms = 1500,
					dot_repeat = false,
				},
				menu = {
					auto_show = true,
					border = "rounded",
					scrollbar = false,
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
				documentation = {
					auto_show = true,
					window = {
						scrollbar = false,
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine",
					},
				},
			},
			signature = { enabled = false },
			fuzzy = {
				implementation = "lua",
			},
			keymap = {
				preset = "default",

				["<Up>"] = { "fallback" },
				["<Down>"] = { "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-Up>"] = { "select_prev", "fallback" },
				["<C-Down>"] = { "select_next", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },

				["<S-CR>"] = { smart_accept, "fallback" },
				["<C-y>"] = { smart_accept, "fallback" },
				["<C-CR>"] = { smart_accept, "fallback" },

				["<C-S-0>"] = {
					function()
						vim.lsp.buf.signature_help()
						return true
					end,
					"fallback",
				},
				["<C-]>"] = {
					function()
						vim.lsp.buf.signature_help()
						return true
					end,
					"fallback",
				},

				["<Tab>"] = {
					function()
						local ms = get_ms()
						if ms.session.get() then
							ms.session.jump("next")
							clear_virt_text()
							return true
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					function()
						local ms = get_ms()
						if ms.session.get() then
							ms.session.jump("prev")
							clear_virt_text()
							return true
						end
					end,
					"fallback",
				},
			},
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
				providers = {
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						max_items = 25,
						timeout_ms = 1000,
					},
					buffer = { max_items = 25 },
					path = { max_items = 25 },
					snippets = {
						name = "snippets",
						enabled = true,
						max_items = 8,
						min_keyword_length = 2,
						module = "blink.cmp.sources.snippets",
					},
					emoji = {
						name = "emoji",
						module = "blink.compat.source",
						transform_items = function(ctx, items)
							local kind = require("blink.cmp.types").CompletionItemKind.Text
							for i = 1, #items do
								items[i].kind = kind
							end
							return items
						end,
					},
				},
			},
		})
	end,
}


