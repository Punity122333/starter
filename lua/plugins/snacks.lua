return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		explorer = {
			enabled = true,
			cycle = false,
			git_status = false,
			win = {
				layout = {
					position = "right",
					width = 0.15,
				},
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
        }
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
		-- Added a quick explorer toggle since it's a right-side sidebar now
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "Toggle Explorer",
		},
	},
}
