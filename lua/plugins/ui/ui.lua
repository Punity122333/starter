return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = false,
			on_highlights = function(hl)
				hl.SignColumn = { bg = "none" }
				hl.LineNr = { bg = "none" }
				hl.StatusLine = { bg = "none" }
				hl.EndOfBuffer = { bg = "none" }
			end,
		},
	},

	{
		"folke/which-key.nvim",
		lazy = false,
		init = function()
			vim.o.timeoutlen = 130
			vim.o.ttimeoutlen = 10
		end,
		opts = {
			delay = 130,
			notify = false,
			win = {
				height = { min = 4, max = 25 },
			},
			spec = {
				{ "<leader>gh", group = "Git Hunks" },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			exclude = {
				file_types = { "Avante", "AvanteInput" },
			},
		},
	},

	{
		"yetone/avante.nvim",
		config = function(_, opts)
			require("avante").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "Avante", "AvanteInput" },
				callback = function(ev)
					vim.treesitter.stop(ev.buf)
				end,
			})
		end,
	},
}
