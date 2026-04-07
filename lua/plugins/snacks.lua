return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		scratch = {
			enabled = true,
			win = {
				layout = {
					position = "center",
					width = 0.5,
					height = 0.5,
					backdrop = false,
				},
				backdrop = false,
			},
		},

		scope = { enabled = false },
		explorer = {
			enabled = true,
			cycle = false,
			git_status = false,
			win = {
				layout = {
					position = "right",
					width = 0.10,
				},
			},
			layout = {
				width = 0.10,
			},
		},
		styles = {
			backdrop = {
				transparent = false,
				blend = 0,
			},
		},
		picker = {
			enabled = true,
			ui_select = true,
			icons = {
				selected = "󰄲 ",
				unselected = "󰄱 ",
				cursor = "❯ ",
			},
			layout = {
				preset = "default",
				preview = false,
				layout = {
					backdrop = false,
				},
			},
			exclude = {
				".git",
				"node_modules",
				"**/*.lock",
				"package.json",
			},
			sources = {
				grep = {
					finder = function(opts, ctx)
						if #(ctx.filter.search or "") < 3 then
							return {}
						end
						return require("snacks.picker.source.grep").grep(opts, ctx)
					end,
				},
				explorer = {
					hidden = true,
					ignored = true,
					win = {
						list = {
							keys = {
								["<C-x>"] = "clear_selection",
							},
						},
					},
					layout = {

						layout = {
							width = 0.16,
							min_width = 0.15,
						},
					},
				},
			},
		},
		input = { enabled = true },
		scroll = { enabled = false },
		words = { enabled = false },
    statuscolumn = { enabled = false },
    image = {
			enabled = true,
			math = { enabled = false },
		},
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.terminal("gitui")
			end,
			desc = "GitUI",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Toggle Explorer",
		},
	},
}
