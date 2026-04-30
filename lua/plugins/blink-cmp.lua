return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	lazy = false,

	opts = function(_, opts)
		local _engine = nil
		local function engine()
			if not _engine then
				_engine = require("snippet_engine")
			end
			return _engine
		end

		local function get_paren_state(line, col)
			local c = line:sub(col, col)
			if not c or not c:match("[%w_%.]") then
				return nil
			end

			if line:sub(col + 1, col + 1) ~= "(" then
				return nil
			end

			if line:sub(col + 1, col + 2) == "()" then
				return "empty"
			end

			return "open"
		end

		-- 🧠 Tree-sitter check for existing closing paren
		local function has_closing_paren_ts(row, col)
			local ok = pcall(vim.treesitter.get_parser, 0)
			if not ok then
				return false
			end

			local node = vim.treesitter.get_node({ pos = { row - 1, col } })
			if not node then
				return false
			end

			while node do
				local t = node:type()

				if t == "call_expression" or t == "function_call" then
					local sr, sc, er, ec = node:range()

					-- if node extends beyond cursor → closing paren exists
					if er > (row - 1) or ec > col then
						return true
					end

					-- fallback check at end of node
					local line = vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1]
					if line and line:sub(ec, ec) == ")" then
						return true
					end

					return false
				end

				node = node:parent()
			end

			return false
		end

		local function smart_accept(cmp)
			if not cmp.is_visible() then
				return false
			end

			-- BEFORE accept
			local pos = vim.api.nvim_win_get_cursor(0)
			local row, col = pos[1], pos[2]
			local line = vim.api.nvim_get_current_line()

			local state = get_paren_state(line, col)

			local ok = cmp.accept()
			if not ok then
				return false
			end

			vim.schedule_wrap(function()
				local pos2 = vim.api.nvim_win_get_cursor(0)
				local row2, col2 = pos2[1], pos2[2]
				local line2 = vim.api.nvim_get_current_line()

				local did_insert = false
				local did_move = false

				-- 🧠 smart insert
				if state == "open" then
					local has_close = false

					-- fast same-line check
					if line2:find(")", col2 + 1, true) then
						has_close = true
					end

					-- Tree-sitter fallback
					if not has_close then
						has_close = has_closing_paren_ts(row2, col2)
					end

					if not has_close then
						vim.api.nvim_buf_set_text(0, row2 - 1, col2, row2 - 1, col2, { ")" })
						line2 = vim.api.nvim_get_current_line()
						did_insert = true
					end
				end

				-- move into "("
				local open = line2:find("(", col2 + 1, true)
				if open then
					vim.api.nvim_win_set_cursor(0, { row2, open })
					did_move = true
				end

				-- shift left ONLY if needed
				if did_insert or did_move then
					local final = vim.api.nvim_win_get_cursor(0)
					if final[2] > 0 then
						vim.api.nvim_win_set_cursor(0, { final[1], final[2] - 1 })
					end
				end
			end)()

			return true
		end

		return vim.tbl_deep_extend("force", opts or {}, {
			enabled = function()
				return vim.b.blink_enabled ~= false and vim.bo.buftype ~= "prompt"
			end,

			snippets = {
				preset = "default",
				expand = function(snippet)
					engine().expand(snippet)
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
				["<A-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<A-p>"] = { "select_prev", "fallback" },
				["<C-Up>"] = { "select_prev", "fallback" },
				["<C-Down>"] = { "select_next", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },

				["<S-CR>"] = { smart_accept, "fallback" },
				["<A-CR>"] = { smart_accept, "fallback" },
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
						local e = engine()
						if e.active(1) then
							e.jump(1)
							return true
						end
						return false
					end,
					"snippet_forward",
					"fallback",
				},

				["<S-Tab>"] = {
					function()
						local e = engine()
						if e.active(-1) then
							e.jump(-1)
							return true
						end
						return false
					end,
					"snippet_backward",
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

						transform_items = function(ctx, items)
							local pos = vim.api.nvim_win_get_cursor(0)
							local col = pos[2]
							local line = vim.api.nvim_get_current_line()

							local state = get_paren_state(line, col)
							if not state then
								return items
							end

							for i = 1, #items do
								local item = items[i]

								if item.insertText and item.insertText:find("(", 1, true) then
									item.insertText = item.insertText:gsub("%b()", "", 1)
								end

								if item.textEdit
									and item.textEdit.newText
									and item.textEdit.newText:find("(", 1, true)
								then
									item.textEdit.newText = item.textEdit.newText:gsub("%b()", "", 1)
								end
							end

							return items
						end,
					},

					buffer = { max_items = 25 },
					path = { max_items = 25 },

					snippets = {
						name = "snippets",
						enabled = true,
						max_items = 8,
						min_keyword_length = 2,
						module = "blink.cmp.sources.snippets",
						opts = {
							friendly_snippets = true,
							search_paths = {
								vim.fn.expand("~/.config/nvim/snippets"),
							},
						},
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


