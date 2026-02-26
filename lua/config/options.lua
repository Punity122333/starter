-- 1. FORCE GLOBAL ROUNDED BORDERS
-- This intercepts Neovim's internal window creation and forces the 'rounded' style
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

-- 2. UNIFIED UI OVERRIDES
local group = vim.api.nvim_create_augroup("TransparentEdges", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = group,
  pattern = "*",
  callback = function()
    local hl = vim.api.nvim_set_hl

    -- Force the rounding characters globally just in case
    -- This affects the diagnostic and hover windows
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- THE NO-DIM / GHOST OVERRIDES
    -- Force these to 'none' so the background never darkens/dims
    hl(0, "NormalNC", { bg = "none" })
    hl(0, "NormalFloat", { bg = "none" })
    -- hl(0, "FloatBorder", { bg = "none", fg = "#89ddff" }) -- Uses your light cyan for the curve
    hl(0, "FloatShadow", { bg = "none" })
    hl(0, "FloatShadowThrough", { bg = "none" })

    -- THE SEAMLESS EDGES
    hl(0, "SignColumn", { bg = "none" })
    hl(0, "LineNr", { bg = "none" })
    hl(0, "EndOfBuffer", { bg = "none" })
    hl(0, "StatusLine", { bg = "none" })
    hl(0, "StatusLineNC", { bg = "none" })

    -- FIX SNACKS SPECIFICALLY
    -- If Snacks is still being boxy, we force its internal highlight group
    hl(0, "SnacksScratch", { bg = "none" })
    hl(0, "SnacksBackdrop", { bg = "none" })
    hl(0, "BlinkCmpSignatureHelp", { bg = "#15151c", blend = 0 })
    hl(0, "BlinkCmpSignatureHelpBorder", { bg = "#15151c", fg = "#232330", blend = 0 })
    hl(0, "BlinkCmpSignatureHelpActiveParameter", { bg = "#15151c", bold = true, blend = 0 })
    hl(0, "NoicePopup", { bg = "#15151c", blend = 0 })
    hl(0, "NoicePopupBorder", { bg = "#15151c", fg = "#232330", blend = 0 })
    hl(0, "LspInfoBorder", { bg = "#15151c", fg = "#232330", blend = 0 })
  end,
})
vim.g.lazygit_config = false -- 3. ALPHA DASHBOARD COLORS
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
-- Stop clipboard from blocking startup
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
