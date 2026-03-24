return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		prompt_func_return_type = {
			go = true,
			java = true,
			cpp = true,
			c = true,
			python = true,
			javascript = true,
			typescript = true,
			typescriptreact = true,
			lua = true,
		},
		prompt_func_param_type = {
			go = true,
			java = true,
			cpp = true,
			c = true,
			python = true,
			javascript = true,
			typescript = true,
			typescriptreact = true,
			lua = true,
		},
	},
	keys = {
		{ "<leader>;e", ":Refactor extract<cr>", mode = "v", desc = "Extract Function", silent = true },
		{ "<leader>;f", ":Refactor extract_to_file<cr>", mode = "v", desc = "Extract to File", silent = true },
		{ "<leader>;i", ":Refactor inline_var<cr>", mode = { "n", "v" }, desc = "Inline Variable", silent = true },
		{ "<leader>;b", ":Refactor extract_block<cr>", mode = "n", desc = "Extract Block", silent = true },
		{
			"<leader>;bf",
			":Refactor extract_block_to_file<cr>",
			mode = "n",
			desc = "Extract Block to File",
			silent = true,
		},
	},
}
