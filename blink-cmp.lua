return {
	"saghen/blink.cmp",
	lazy = false,
	opts = function(_, opts)
		local _copilot = nil
		local function get_copilot()
			if _copilot == nil then
				local ok, m = pcall(require, "copilot.suggestion")
				_copilot = ok and m or false
			end
			return _copilot ~= false and _copilot or nil
		end

		local _ls = nil
		local function get_ls()
			if not _ls then
				_ls = require("luasnip")
			end
			return _ls
		end

		local _ns = vim.api.nvim_create_namespace("fast_snip")
		local _snip = nil

		local function snip_clear()
			if _snip then
				for _, id in ipairs(_snip.marks) do
					pcall(vim.api.nvim_buf_del_extmark, _snip.buf, _ns, id)
				end
				_snip = nil
			end
		end

		vim.api.nvim_create_autocmd("InsertLeave", { callback = snip_clear })

		local function snip_jump_to(i)
			if not _snip then
				return false
			end
			if i > #_snip.marks then
				snip_clear()
				return false
			end
			if i < 1 then
				return false
			end

			_snip.idx = i
			local mark = vim.api.nvim_buf_get_extmark_by_id(_snip.buf, _ns, _snip.marks[i], { details = true })

			local row = mark[1] + 1
			local scol = mark[2]
			local ecol = mark[3].end_col

			-- FIX: no key feeding → no toggleterm trigger
			vim.cmd("stopinsert")

			vim.schedule(function()
				vim.api.nvim_win_set_cursor(0, { row, scol })
				if ecol > scol then
					local extend = ecol - scol - 1
					vim.api.nvim_feedkeys("gh" .. (extend > 0 and (extend .. "l") or ""), "n", false)
				else
					vim.api.nvim_feedkeys("i", "n", false)
				end
			end)

			return true
		end

		local function snip_forward()
			return _snip and snip_jump_to(_snip.idx + 1)
		end

		local function snip_backward()
			return _snip and snip_jump_to(_snip.idx - 1)
		end

		local function fast_expand(snippet, row, col, dedup)
			snip_clear()

			local s = snippet:gsub("%$0", "")

			local parts = {}
			local raw_nodes = {}
			local pos = 0
			local i = 1

			while i <= #s do
				local ms, me, snum, stext = s:find("%${(%d+):([^}]*)}", i)
				local bs, be, bnum = s:find("%$(%d+)", i)

				if ms and (not bs or ms <= bs) then
					local head = s:sub(i, ms - 1)
					parts[#parts + 1] = head
					pos = pos + #head
					raw_nodes[#raw_nodes + 1] = { n = tonumber(snum), pos = pos, len = #stext }
					parts[#parts + 1] = stext
					pos = pos + #stext
					i = me + 1
				elseif bs then
					local head = s:sub(i, bs - 1)
					parts[#parts + 1] = head
					pos = pos + #head
					raw_nodes[#raw_nodes + 1] = { n = tonumber(bnum), pos = pos, len = 0 }
					i = be + 1
				else
					parts[#parts + 1] = s:sub(i)
					break
				end
			end

			local plain = table.concat(parts)
			table.sort(raw_nodes, function(a, b)
				return a.n < b.n
			end)

			vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { plain })

			if dedup then
				local cl = vim.api.nvim_get_current_line()
				local fixed = cl:gsub("%)%(%)$", ")"):gsub("%)%(%)([^%w%(])", function(ch)
					return ")" .. ch
				end)
				if fixed ~= cl then
					vim.api.nvim_set_current_line(fixed)
				end
			end

			if #raw_nodes == 0 then
				local paren = plain:find("%(")
				vim.api.nvim_win_set_cursor(0, { row, col + (paren or #plain) })
				return
			end

			local buf = vim.api.nvim_get_current_buf()
			local marks = {}
			for _, node in ipairs(raw_nodes) do
				marks[#marks + 1] = vim.api.nvim_buf_set_extmark(buf, _ns, row - 1, col + node.pos, {
					end_col = col + node.pos + node.len,
					right_gravity = false,
					end_right_gravity = true,
				})
			end

			_snip = { buf = buf, marks = marks, idx = 0 }

			vim.schedule(function()
				snip_jump_to(1)
			end)
		end

		local function paren_context()
			local cursor = vim.api.nvim_win_get_cursor(0)
			local col = cursor[2]
			local line = vim.api.nvim_get_current_line()
			local rest = line:sub(col + 1)
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
					local cursor = vim.api.nvim_win_get_cursor(0)
					local row, col = cursor[1], cursor[2]
					local line = vim.api.nvim_get_current_line()
					local rest = line:sub(col + 1)
					local word_tail = rest:match("^[%w_%.]*") or ""
					local after = rest:sub(#word_tail + 1)
					local inside = after:match("^%((.-)%)")

					if inside ~= nil and inside:match("%S") then
						local name = snippet:match("^([%w_%.:<>~]+)") or snippet
						vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { name })
						vim.api.nvim_win_set_cursor(0, { row, col + #name })
					else
						fast_expand(snippet, row, col, inside ~= nil)
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
					auto_brackets = { enabled = false },
					resolve_timeout_ms = 200,
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
						if _snip then
							return snip_forward()
						end

						local copilot = get_copilot()
						if copilot and copilot.is_visible() then
							copilot.accept()
							return true
						end

						local luasnip = get_ls()
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
							return true
						end

						if cmp.is_visible() then
							return cmp.accept()
						end

						local col = vim.api.nvim_win_get_cursor(0)[2]
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
						if _snip then
							return snip_backward()
						end

						local luasnip = get_ls()
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
							return true
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
