return {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	opts = {
		library = {
			{ path = "${3rd}/luvit-meta/library", words = { "vim%.uv" } },
			{ path = "${3rd}/love2d/library", words = { "love" } },
			{ path = "${3rd}/busted/library", words = { "describe" } },
			"LazyVim",
		},
		enabled = function(root_dir)
			return vim.g.lazydev_enabled ~= false
		end,
	},
}
