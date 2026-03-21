return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		explorer = {
			enabled = true,
			cycle = false,
			win = {
				layout = {
					position = "right",
					width = 0.15,
				},
			},
		},
		picker = {
			enabled = true,
			icons = {
				selected = "󰄲 ",
				unselected = "󰄱 ",
				cursor = "❯ ",
			},
			layout = {
				preset = "default",
			},
			live_grep = {
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
          
				},
			},
		},

		input = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		image = { enabled = true },
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.terminal("gitui")
			end,
			desc = "GitUI",
		},
	},
}
