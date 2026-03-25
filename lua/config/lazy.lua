local LAZYPATH = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local LAZYREPO = "https://github.com/folke/lazy.nvim.git"
local COLORSCHEMES = { "tokyonight", "habamax" }

if not (vim.uv or vim.loop).fs_stat(LAZYPATH) then
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", LAZYREPO, LAZYPATH })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(LAZYPATH)

local force_all = os.getenv("NO_LAZY") == "1"

require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "plugins" },
	},
	defaults = {
		lazy = not force_all,
		version = false,
	},
  ui = {
    backdrop = 100,
  },
	concurrency = force_all and 100 or nil,
	performance = {
		cache = { enabled = true },
		reset_packpath = true,
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	install = { colorscheme = COLORSCHEMES },
	checker = { enabled = true, notify = false },
	ui = { backdrop = 100, border = "rounded" },
})

if force_all then
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local lazy_config = require("lazy.core.config")
			local plugins = {}
			for name, _ in pairs(lazy_config.plugins) do
				table.insert(plugins, name)
			end
			require("lazy").load({ plugins = plugins })
		end,
	})
end
