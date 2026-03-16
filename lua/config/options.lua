vim.opt.timeoutlen = 130
vim.opt.ttimeoutlen = 10
vim.g.autoformat = false
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_set_option_value(
      "winhighlight",
      "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      { win = winnr }
    )
  end
  return bufnr, winnr
end


vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = group,
  pattern = "*",
  callback = function()
    local hl = vim.api.nvim_set_hl
    require("lspconfig.ui.windows").default_options.border = "rounded"
    hl(0, "NormalNC", { bg = "none" })
    hl(0, "NormalFloat", { bg = "none" })
    hl(0, "FloatShadow", { bg = "none" })
    hl(0, "FloatShadowThrough", { bg = "none" })
    hl(0, "SignColumn", { bg = "none" })
    hl(0, "LineNr", { bg = "none" })
    hl(0, "EndOfBuffer", { bg = "none" })
    hl(0, "StatusLine", { bg = "none" })
    hl(0, "StatusLineNC", { bg = "none" })
    hl(0, "SnacksScratch", { bg = "none" })
    hl(0, "SnacksBackdrop", { bg = "none" })
    hl(0, "BlinkCmpSignatureHelp", { bg = "#15151c", blend = 0 })
    hl(0, "BlinkCmpSignatureHelpBorder", { bg = "#15151c", fg = "#232330", blend = 0 })
    hl(0, "BlinkCmpSignatureHelpActiveParameter", { bg = "#15151c", bold = true, blend = 0 })
    hl(0, "LspInfoBorder", { bg = "#15151c", fg = "#232330", blend = 0 })
  end,
})
vim.g.lazygit_config = false
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    local hl = vim.api.nvim_set_hl
    hl(0, "AlphaHeader", { fg = "#7aa2f7" })
    hl(0, "AlphaButtons", { fg = "#bb9af7" })
    hl(0, "AlphaShortcut", { fg = "#ff9e64" })
    hl(0, "AlphaFooter", { fg = "#565f89" })

  end,
})

vim.opt.clipboard = "unnamedplus"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
end
vim.opt.foldenable = false
vim.env.PATH = vim.fn.expand("~/.npm-global/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.VM_theme = "neon"
vim.opt.concealcursor = ""
vim.g.VM_SET_STATUS_LINE = 0
vim.g.VM_set_statusline = 0

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
end
vim.opt.foldenable = false
vim.o.winborder = "rounded"
