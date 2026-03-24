return {
	"nvim-mini/mini.move",
	version = "*",
	opts = {
		mappings = {
			left = "<A-h>",
			right = "<A-l>",
			down = "<A-j>",
			up = "<A-k>",
			line_left = "<A-S-h>",
			line_right = "<A-S-l>",
			line_down = "<A-S-j>",
			line_up = "<A-S-k>",
		},
		options = {
			reindent_linewise = true,
		},
	},
	config = function(_, opts)
		require("mini.move").setup(opts)
	end,
}
