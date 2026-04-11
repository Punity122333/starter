return {
	"saghen/blink.cmp",
	lazy = false,
	opts = function(_, opts)
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
				preset = "luasnip",
				expand = function(snippet)
					local ls = require("luasnip")
					local col = vim.fn.col(".")
					local line = vim.api.nvim_get_current_line()
					local rest = line:sub(col)
					local word_tail = rest:match("^[%w_%.]*") or ""
					local after = rest:sub(#word_tail + 1)
					local inside = after:match("^%((.-)%)")

					local has_real_args = inside ~= nil and inside:match("%S") ~= nil
					local has_empty_paren = inside ~= nil and not inside:match("%S")

					if has_real_args then
						local name = snippet:match("^([%w_%.]+)") or snippet
						local row, c = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_buf_set_text(0, row - 1, c, row - 1, c, { name })
						vim.api.nvim_win_set_cursor(0, { row, c + #name })
					elseif has_empty_paren then
						ls.lsp_expand(snippet)
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
						ls.lsp_expand(snippet)
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
				["<S-CR>"] = { smart_accept, "fallback" },
				["<C-y>"] = { smart_accept, "fallback" },


				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
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
					function(cmp)
						local copilot_ok, copilot = pcall(require, "copilot.suggestion")
						if copilot_ok and copilot.is_visible() then
							copilot.accept()
							return true
						end

						local luasnip = require("luasnip")
						if luasnip.expand_or_jumpable() then
							return luasnip.expand_or_jump()
						end

						if cmp.is_visible() then
							return cmp.accept()
						end

						local col = vim.fn.col(".") - 1
						local line = vim.api.nvim_get_current_line()
						if col == 0 or line:sub(col, col):match("%s") then
							return false
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function()
						local luasnip = require("luasnip")
						if luasnip.jumpable(-1) then
							return luasnip.jump(-1)
						end
					end,
					"snippet_backward",
					"fallback",
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
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
						---@diagnostic disable-next-line: unused-local
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
