return {
	"tigion/swap.nvim",
	keys = {
		{
			"<leader>Ci",
			function()
				require("swap").switch()
			end,
			desc = "Swap word",
		},
		{
			"<leader>Co",
			function()
				require("swap").opposites.switch()
			end,
			desc = "Swap opposite",
		},
		{
			"<leader>Cn",
			function()
				require("swap").chains.switch()
			end,
			desc = "Swap next",
		},
		{
			"<leader>Cc",
			function()
				require("swap").cases.switch()
			end,
			desc = "Swap case",
		},
	},
	opts = {},
	config = function(_, opts)
		require("swap").setup(opts)
	end,
}
