local COLOR_SIGNATURE_BG = "#15151c"
local COLOR_SIGNATURE_BORDER = "#232330"
local COLOR_ALPHA_HEADER = "#7aa2f7"
local COLOR_ALPHA_BUTTONS = "#bb9af7"
local COLOR_ALPHA_SHORTCUT = "#ff9e64"
local COLOR_ALPHA_FOOTER = "#565f89"
local HIGHLIGHT_NONE = "none"
local BORDER_ROUNDED = "rounded"
local WINHIGHLIGHT_SIGNATURE = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder"
local KITTY_SCROLLBACK_NVIM = "KITTY_SCROLLBACK_NVIM"
local TRUE = "true"
local NPM_GLOBAL_BIN = "~/.npm-global/bin:"
local LOCAL_BIN = "~/.local/bin:"
local MASON_BIN = "~/.local/share/nvim/mason/bin:"

vim.opt.timeoutlen = 130
vim.opt.ttimeoutlen = 10
vim.g.autoformat = false
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or BORDER_ROUNDED
  local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_set_option_value(
      "winhighlight",
      WINHIGHLIGHT_SIGNATURE,
      { win = winnr }
    )
  end
  return bufnr, winnr
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
---@diagnostic disable-next-line: undefined-global
  group = group,
  pattern = "*",
  callback = function()
    local hl = vim.api.nvim_set_hl
    require("lspconfig.ui.windows").default_options.border = BORDER_ROUNDED
    hl(0, "NormalNC", { bg = HIGHLIGHT_NONE })
    hl(0, "NormalFloat", { bg = HIGHLIGHT_NONE })
    hl(0, "FloatShadow", { bg = HIGHLIGHT_NONE })
    hl(0, "FloatShadowThrough", { bg = HIGHLIGHT_NONE })
    hl(0, "SignColumn", { bg = HIGHLIGHT_NONE })
    hl(0, "LineNr", { bg = HIGHLIGHT_NONE })
    hl(0, "EndOfBuffer", { bg = HIGHLIGHT_NONE })
    hl(0, "StatusLine", { bg = HIGHLIGHT_NONE })
    hl(0, "StatusLineNC", { bg = HIGHLIGHT_NONE })

    hl(0, "SnacksScratch", { bg = HIGHLIGHT_NONE })
    hl(0, "SnacksBackdrop", { bg = HIGHLIGHT_NONE })
    hl(0, "BlinkCmpSignatureHelp", { bg = COLOR_SIGNATURE_BG, blend = 0 })
    hl(0, "BlinkCmpSignatureHelpBorder", { bg = COLOR_SIGNATURE_BG, fg = COLOR_SIGNATURE_BORDER, blend = 0 })
    hl(0, "BlinkCmpSignatureHelpActiveParameter", { bg = COLOR_SIGNATURE_BG, bold = true, blend = 0 })
    hl(0, "LspInfoBorder", { bg = COLOR_SIGNATURE_BG, fg = COLOR_SIGNATURE_BORDER, blend = 0 })
  end,
})
vim.g.lazygit_config = false
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    local hl = vim.api.nvim_set_hl
    hl(0, "AlphaHeader", { fg = COLOR_ALPHA_HEADER })
    hl(0, "AlphaButtons", { fg = COLOR_ALPHA_BUTTONS })
    hl(0, "AlphaShortcut", { fg = COLOR_ALPHA_SHORTCUT })
    hl(0, "AlphaFooter", { fg = COLOR_ALPHA_FOOTER })
  end,
})

vim.opt.clipboard = "unnamedplus"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
if vim.env[KITTY_SCROLLBACK_NVIM] == TRUE then
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
end
vim.opt.foldenable = false
vim.env.PATH = vim.fn.expand(NPM_GLOBAL_BIN) .. vim.env.PATH
vim.env.PATH = vim.fn.expand(LOCAL_BIN) .. vim.env.PATH
vim.env.PATH = vim.fn.expand(MASON_BIN) .. vim.env.PATH
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.VM_theme = "neon"
vim.opt.concealcursor = ""
vim.g.VM_SET_STATUS_LINE = 0
vim.g.VM_set_statusline = 0
vim.opt.shiftwidth = 4

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
if vim.env[KITTY_SCROLLBACK_NVIM] == TRUE then
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
end
vim.opt.foldenable = false
vim.o.winborder = BORDER_ROUNDED

