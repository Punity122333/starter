return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			shade_terminals = false,
			direction = "float",
			float_opts = {
				border = "rounded",
				winblend = 3,
			},
			highlights = {
				Normal = {
					guibg = "#1a1b26",
				},
				border = {
					guifg = "#27a1b9",
					guibg = "#1a1b26",
				},
			},
		})
	end,
}
