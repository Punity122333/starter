return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		return vim.tbl_deep_extend("force", opts or {}, {
			enabled = function()
				return vim.b.blink_enabled ~= false and vim.bo.buftype ~= "prompt"
			end,
			snippets = {
				preset = "luasnip",
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
				["<S-CR>"] = { "accept", "fallback" },
				["<C-y>"] = { "accept", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-CR>"] = { "accept", "fallback" },
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
						score_offset = 85, 
					},
				},
			},
		})
	end,
}
