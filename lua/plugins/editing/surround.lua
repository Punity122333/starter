return {
	{ "nvim-mini/mini.surround", enabled = false },

	{
		"kylechui/nvim-surround",
		version = "*",
		lazy = false,
		init = function()
			vim.g.nvim_surround_no_insert_mappings = true
			vim.g.nvim_surround_no_normal_mappings = true
			vim.g.nvim_surround_no_visual_mappings = true
		end,
		config = function()
			require("nvim-surround").setup({
				move_cursor = false,
			})

			local keymap = vim.keymap.set

			keymap("n", "gsa", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding" })
			keymap("n", "gsd", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding" })
			keymap("n", "gsr", "<Plug>(nvim-surround-change)", { desc = "Replace surrounding" })
			keymap("n", "gss", "<Plug>(nvim-surround-normal-cur)", { desc = "Surround current line" })

			keymap("x", "gs", "<Plug>(nvim-surround-visual)", { desc = "Surround selection" })
		end,
	},
}

