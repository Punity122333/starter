return {
	"allaman/emoji.nvim",
	ft = { "markdown", "text" }, -- load only in those filetypes
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp", -- optional (emoji completion)
		"nvim-telescope/telescope.nvim", -- optional (emoji picker)
	},
	opts = {
		enable_cmp_integration = true, -- allows emoji in cmp menu
	},
	config = function(_, opts)
		require("emoji").setup(opts)

		local has_telescope, telescope = pcall(require, "telescope")
		if has_telescope then
			telescope.load_extension("emoji")
			vim.keymap.set("n", "<leader>se", telescope.extensions.emoji.emoji, { desc = "Search Emojis" })
		end
	end,
}
