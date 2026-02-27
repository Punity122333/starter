local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
vim.opt.rtp:prepend(lazypath)

-- Check if we want to bypass all lazy loading
local force_all = os.getenv("NO_LAZY") == "1"

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- If NO_LAZY=1, this forces EVERY plugin to load on startup
    lazy = not force_all,
    version = false,
  },
  -- This is the secret sauce:
  -- It overrides the 'lazy' property on every plugin spec before loading
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
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  ui = { backdrop = 100 },
})

-- If we are in God Mode, force a manual load of everything right now
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

