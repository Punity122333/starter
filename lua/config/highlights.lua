---@diagnostic disable: undefined-global
local COLOR_BACKGROUND_PRIMARY = "#1a1b26"
local COLOR_SELECTION_BLUE = "#28344a"
local COLOR_BACKGROUND_SECONDARY = "#111116"
local COLOR_FOREGROUND_ACCENT = "#111116"
local COLOR_FOREGROUND_SECONDARY = "#232330"
local COLOR_CURSOR_FOREGROUND = "#000000"
local COLOR_CURSOR_BACKGROUND = "#00ff00"
local COLOR_SNACKS_SELECTION_BG = "#1a1b26"
local COLOR_SNACKS_PICKER_SELECTED = "#88c0d0"
local COLOR_NOICE_BORDER = "#27a1b9"
local COLOR_MASON_HIGHLIGHT = "#e0af68"
local COLOR_MASON_MUTED = "#27a1b9"
local COLOR_LSP_TYPE_VARIABLE = "#9CDCFE"
local COLOR_LSP_TYPE_MACRO_CPP = "#3497E7"

vim.api.nvim_set_hl(0, "markdownBold", { bold = true, force = true })
vim.api.nvim_set_hl(0, "@markup.strong", { bold = true, force = true })
vim.api.nvim_set_hl(0, "@text.strong", { bold = true, force = true })

local sel_groups = { "BlinkCmpMenuSelection", "PmenuSel", "CmpItemAbbrSelected", "TelescopeSelection" }
for _, g in ipairs(sel_groups) do
  vim.api.nvim_set_hl(0, g, { bg = COLOR_SELECTION_BLUE, force = true })
end

local float_groups = { "NormalFloat", "FloatTitle", "MsgArea", "StatusLine", "StatusLineNC" }
for _, g in ipairs(float_groups) do
  vim.api.nvim_set_hl(0, g, { bg = COLOR_BACKGROUND_PRIMARY, force = true })
end

local blink = {
  "BlinkCmpDocSeparator",
  "NoiceLspSignatureHelp",
}
for _, g in ipairs(blink) do
  vim.api.nvim_set_hl(0, g, { bg = COLOR_BACKGROUND_SECONDARY, blend = 0, force = true })
end
vim.api.nvim_set_hl(0, "NoicePopupBorder", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })

vim.api.nvim_set_hl(0, "NoicePopupBorderSearch", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })
vim.api.nvim_set_hl(0, "NoicePopupBorderInput", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })
vim.api.nvim_set_hl(0, "NoicePopupTitleSearch", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })
vim.api.nvim_set_hl(0, "NoicePopupTitleInput", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
vim.api.nvim_set_hl(0, "Pmenu", { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { bg = NONE, fg = COLOR_NOICE_BORDER, blend = 0, force = true })

vim.api.nvim_set_hl(0, "NoicePopup", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
vim.api.nvim_set_hl(
  0,
  "LspInfoBorder",
  { bg = COLOR_BACKGROUND_SECONDARY, fg = COLOR_FOREGROUND_SECONDARY, blend = 0, force = true }
)
local sep = { "Split", "Splitter", "Separator", "WinSeparator", "VertSplit" }
for _, g in ipairs(sep) do
  vim.api.nvim_set_hl(0, g, { bg = COLOR_BACKGROUND_PRIMARY, blend = 20, fg = COLOR_FOREGROUND_ACCENT, force = true })
end
vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", { fg = COLOR_FOREGROUND_ACCENT, bg = COLOR_BACKGROUND_PRIMARY })
vim.api.nvim_set_hl(
  0,
  "AvanteSidebarWinHorizontalSeparator",
  { fg = COLOR_FOREGROUND_ACCENT, bg = COLOR_BACKGROUND_PRIMARY }
)
vim.api.nvim_set_hl(0, "AvantePopup", { bg = COLOR_BACKGROUND_PRIMARY, force = true, blend = 0 })

vim.api.nvim_set_hl(0, "AvantePopupHint", { bg = COLOR_BACKGROUND_PRIMARY, force = true, blend = 0 })
local snack_hls = {
  SnacksPickerSelected = { bg = "NONE", fg = COLOR_SNACKS_PICKER_SELECTED },
  SnacksPickerCursorLine = { bg = COLOR_SNACKS_SELECTION_BG },
}
for group, settings in pairs(snack_hls) do
  vim.api.nvim_set_hl(0, group, settings)
end
vim.api.nvim_set_hl(0, "AvantePromptInput", { bg = COLOR_BACKGROUND_PRIMARY, force = true, blend = 0 })

vim.api.nvim_set_hl(
  0,
  "AvantePromptInputBorder",
  { bg = COLOR_BACKGROUND_PRIMARY, fg = COLOR_NOICE_BORDER, force = true, blend = 0 }
)
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "MasonHeader", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "MasonHeaderSecondary", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "MasonHighlightBlockBold", { fg = COLOR_MASON_HIGHLIGHT, force = true })
vim.api.nvim_set_hl(0, "MasonMutedBlock", { fg = COLOR_MASON_MUTED, force = true })

vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = COLOR_NOICE_BORDER, bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = COLOR_NOICE_BORDER, bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureActiveParameter", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
vim.api.nvim_set_hl(0, "Cursor", { fg = COLOR_CURSOR_FOREGROUND, bg = COLOR_CURSOR_BACKGROUND, force = true })
vim.api.nvim_set_hl(0, "lCursor", { fg = COLOR_CURSOR_FOREGROUND, bg = COLOR_CURSOR_BACKGROUND, force = true })
vim.api.nvim_set_hl(0, "CursorIM", { fg = COLOR_CURSOR_FOREGROUND, bg = COLOR_CURSOR_BACKGROUND, force = true })
vim.api.nvim_set_hl(0, "TermCursor", { fg = COLOR_CURSOR_FOREGROUND, bg = COLOR_CURSOR_BACKGROUND, force = true })
vim.api.nvim_set_hl(0, "@module.python", { link = "@type.python" })
vim.api.nvim_set_hl(0, "@keyword.import.python", { link = "@keyword.conditional.python" })
vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "@module.python" })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = COLOR_LSP_TYPE_VARIABLE })
vim.api.nvim_set_hl(0, "@variable", { fg = COLOR_LSP_TYPE_VARIABLE })
vim.api.nvim_set_hl(0, "@lsp.type.macro.cpp", { fg = COLOR_LSP_TYPE_MACRO_CPP })
vim.api.nvim_set_hl(0, "GrugFarResultsMatch", { link = "@type.builtin.cpp" })
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "NONE" })
