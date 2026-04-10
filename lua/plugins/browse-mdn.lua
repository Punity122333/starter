return {
	"lalitmee/browse.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	keys = {
		{
			"<leader>Bw",
			function()
				require("browse").input_search()
			end,
			desc = "Browse Search",
		},
		{
			"<leader>Bb",
			function()
				require("browse").browse()
			end,
			desc = "Browse Main Menu",
		},
		{
			"<leader>Bm",
			function()
				require("browse").open_manual_bookmarks()
			end,
			desc = "Browse Bookmarks",
		},
		{
			"<leader>Bt",
			function()
				require("browse.devdocs").search()
			end,
			desc = "Browse DevDocs",
		},
	},
	opts = {
		provider = "google",
		icons = {
			bookmark = "󰆤 ",
			folder = "󰉋 ",
		},
		bookmarks = {
			["Neovim Repo"] = "https://github.com/neovim/neovim",
			["Telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
			["LeetCode"] = "https://leetcode.com/",
		},
		search_engines = {
			github = "https://github.com/search?q=%s",
			reddit = "https://www.reddit.com/search/?q=%s",
			crates = "https://crates.io/search?q=%s",
		},
	},
	config = function(_, opts)
		require("browse").setup(opts)

		local cmd = vim.api.nvim_create_user_command

		cmd("BrowseMain", function()
			require("browse").browse()
		end, {})
		cmd("BrowseInput", function()
			require("browse").input_search()
		end, {})
		cmd("BrowseBookmarks", function()
			require("browse").open_manual_bookmarks()
		end, {})
		cmd("BrowseDevDocs", function()
			require("browse.devdocs").search()
		end, {})
		cmd("BrowseDevDocsFT", function()
			require("browse.devdocs").search_with_filetype()
		end, {})
		cmd("BrowseMDN", function()
			require("browse.mdn").search()
		end, {})
	end,
}
