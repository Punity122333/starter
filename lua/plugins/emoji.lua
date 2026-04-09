return {
	"allaman/emoji.nvim",
	ft = { "markdown", "text" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		enable_cmp_integration = true,
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
