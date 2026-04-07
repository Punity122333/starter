return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			shade_terminals = false,
			close_on_exit = true,
			direction = "float",
			float_opts = {
				border = "rounded",
				winblend = 0,
			},
			highlights = {
				Normal = { guibg = "#1a1b26" },
				FloatBorder = { guifg = "#27a1b9", guibg = "#1a1b26" },
			},
			on_exit = function(t, job, exit_code, name)
				if exit_code == 0 then
					t:close()
				end
			end,
		})
	end,
}
