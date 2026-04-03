return {
	{
		"h3pei/case-dial.nvim",
		opts = {
			keymap = false,
		},
		config = function(_, opts)
			require("case-dial").setup(opts)

			vim.keymap.set("n", "<C-q>", function()
				require("case-dial").dial_normal()
			end, { desc = "Dial Case" })

			vim.keymap.set("v", "<C-q>", function()
				require("case-dial").dial_visual()
			end, { desc = "Dial Case" })
		end,
	},
}
