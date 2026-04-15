return {
	"saghen/blink.cmp",
	dependencies = { "nvim-mini/mini.snippets" },
	lazy = false,
	opts = function(_, opts)
		-- ── Cached module refs ───────────────────────────────────────────────

		local _ls = nil
		local function get_ls()
			if not _ls then
				_ls = require("luasnip")
			end
			return _ls
		end

		local function accept_and_enter_parens(cmp)
			if not cmp.is_visible() then
				return false
			end

			local ok = cmp.accept()
			if ok then
				vim.schedule(function()
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local line = vim.api.nvim_get_current_line()

					if line:sub(col + 1, col + 2) == "()" then
						vim.api.nvim_win_set_cursor(0, { row, col + 1 })
					elseif col >= 1 and line:sub(col, col + 1) == "()" then
						vim.api.nvim_win_set_cursor(0, { row, col })
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
				preset = "mini_snippets",
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
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },

				["<S-CR>"] = { accept_and_enter_parens, "fallback" },
				["<C-y>"] = { accept_and_enter_parens, "fallback" },
				["<C-CR>"] = { accept_and_enter_parens, "fallback" },

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

				-- 🚀 CLEAN TAB (fixed)
				["<Tab>"] = {
					function()
						local ls = get_ls()
						if ls.jumpable(1) then
							ls.jump(1)
							return true
						end
						return false
					end,
					"snippet_forward",
					"fallback",
				},

				-- 🔥 CLEAN SHIFT-TAB
				["<S-Tab>"] = {
					function()
						local ls = get_ls()
						if ls.jumpable(-1) then
							ls.jump(-1)
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
