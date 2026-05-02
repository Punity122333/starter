return {
	{
		"folke/flash.nvim",
		lazy = false,
		opts = {
			modes = {
				char = {
					enabled = false,
					jump_labels = false,
				},
				search = {
					enabled = false,
					multi_line = true,
					wrap = true,
				},
			},
			jump = {
				autojump = false,
				multi_line = true,
			},
			repeat_op = true,
		},
	},
}
