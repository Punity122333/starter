return {
	{
		"Punity122333/snipe.nvim", -- updated to your github handle
		-- dir = "~/projects/snipe.nvim", -- keeps local dev active
		lazy = false,
		priority = 1000,
		config = function()
			require("snipe").setup({
				-- your default options
			})
		end,
	},
}
