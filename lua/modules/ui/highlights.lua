---@diagnostic disable: undefined-global
local COLOR_BACKGROUND_PRIMARY = "#1a1b26"
local COLOR_SELECTION_BLUE = "#28344a"
local COLOR_BACKGROUND_SECONDARY = "#111116"
local COLOR_FOREGROUND_ACCENT = "#111116"
local COLOR_FOREGROUND_SECONDARY = "#232330"
local COLOR_SNACKS_SELECTION_BG = "#1a1b26"
local COLOR_SNACKS_PICKER_SELECTED = "#88c0d0"
local COLOR_BORDER = "#27a1b9"
local COLOR_MASON_HIGHLIGHT = "#e0af68"
local COLOR_MASON_MUTED = "#27a1b9"
local COLOR_LSP_TYPE_VARIABLE = "#9CDCFE"
local COLOR_LSP_TYPE_MACRO_CPP = "#3497E7"
local COLOR_GENERAL_NONE = "NONE"
local COLOR_STATUS_LINE = "#16161e"
local GUICURSOR_DEFAULT = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

local set = vim.api.nvim_set_hl

local function hl(groups, opts)
    for _, g in ipairs(groups) do
        set(0, g, opts)
    end
end

set(0, "markdownBold", { bold = true, force = true })
set(0, "@markup.strong", { bold = true, force = true })
set(0, "@text.strong", { bold = true, force = true })

hl({
    "BlinkCmpMenuSelection",
    "PmenuSel",
    "CmpItemAbbrSelected",
    "TelescopeSelection",
}, { bg = COLOR_SELECTION_BLUE, force = true })

hl({
    "NormalFloat",
    "FloatTitle",
    "MsgArea",
    "StatusLine",
    "StatusLineNC",
}, { bg = COLOR_BACKGROUND_PRIMARY, force = true })

hl({
    "BlinkCmpDocSeparator",
    "NoiceLspSignatureHelp",
}, { bg = COLOR_BACKGROUND_SECONDARY, blend = 0, force = true })

hl({
    "NoicePopupBorder",
    "NoicePopupBorderSearch",
    "NoicePopupBorderInput",
    "NoicePopupmenuBorder",
}, { bg = COLOR_GENERAL_NONE, fg = COLOR_BORDER, blend = 0, force = true })

hl({
    "NoicePopupTitleSearch",
    "NoicePopupTitleInput",
}, { bg = COLOR_GENERAL_NONE, fg = COLOR_BORDER, blend = 0, force = true })

hl({
    "NoicePopup",
    "Pmenu",
    "LspSignatureActiveParameter",
    "BlinkCmpSignatureHelpBorder",
    "BlinkCmpSignatureHelp",
}, { bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })

set(0, "GitSignsAdd", { link = "@string", force = true })
set(0, "@mutable", { fg = "#ff9e64", italic = true, bold = true })
set(0, "@type.builtin", { link = "Type" })

local function bufferline_group(name, color)
    set(0, "BufferLine" .. name, { fg = color, bg = COLOR_BACKGROUND_PRIMARY, blend = 0, force = true })
    set(0, "BufferLine" .. name .. "Selected", { fg = color, bg = COLOR_BACKGROUND_PRIMARY, bold = true, force = true })
    set(0, "BufferLine" .. name .. "Diagnostic", { fg = color, bg = COLOR_BACKGROUND_PRIMARY, force = true })
    set(0, "BufferLine" .. name .. "DiagnosticSelected",
        { fg = color, bg = COLOR_BACKGROUND_PRIMARY, bold = true, force = true })
end

bufferline_group("Error", "#f7768e")
bufferline_group("Warning", "#e0af68")
bufferline_group("Info", "#7dcfff")
bufferline_group("Hint", "#1abc9c")

set(0, "BufferLineModified", { fg = "#ff9e64", bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "BufferLineModifiedSelected", { fg = "#ff9e64", bg = COLOR_BACKGROUND_PRIMARY, bold = true, force = true })

set(0, "LspInfoBorder", { bg = COLOR_BACKGROUND_PRIMARY, force = true })

hl({ "Split", "Splitter", "Separator", "WinSeparator", "VertSplit" }, {
    bg = COLOR_BACKGROUND_PRIMARY,
    blend = 20,
    fg = COLOR_FOREGROUND_ACCENT,
    force = true,
})

hl({ "AvanteSidebarWinSeparator", "AvanteSidebarWinHorizontalSeparator" }, {
    fg = COLOR_FOREGROUND_ACCENT,
    bg = COLOR_BACKGROUND_PRIMARY,
})

hl({ "AvantePopup", "AvantePopupHint" }, { bg = COLOR_BACKGROUND_PRIMARY, force = true, blend = 0 })

set(0, "SnacksPickerSelected", { bg = COLOR_GENERAL_NONE, fg = COLOR_SNACKS_PICKER_SELECTED })
set(0, "SnacksPickerCursorLine", { bg = COLOR_SNACKS_SELECTION_BG })

set(0, "AvantePromptInput", { bg = COLOR_BACKGROUND_PRIMARY, force = true, blend = 0 })
set(0, "AvantePromptInputBorder", { bg = COLOR_BACKGROUND_PRIMARY, fg = COLOR_BORDER, force = true, blend = 0 })

hl({ "@keyword.repeat", "@keyword.conditional" }, { link = "@keyword" })
set(0, "@bracket.square", { fg = "#7aa2f7" })
set(0, "@bracket.paren", { fg = "#f38ba8" })
set(0, "@bracket.curly", { fg = "#fab387" })

hl({ "DapUIPlayPause", "DapUIStepOver", "DapUIStepInto", "DapUIStepOut" },
    { fg = "#7dcfff", bg = COLOR_BACKGROUND_PRIMARY })
set(0, "DapUIRestart", { fg = "#ff9e64", bg = COLOR_BACKGROUND_PRIMARY })
set(0, "DapUIStop", { fg = "#f7768e", bg = COLOR_BACKGROUND_PRIMARY })
set(0, "DapUIUnavailable", { fg = "#565f89", bg = COLOR_BACKGROUND_PRIMARY })

hl({ "DapUIControls", "DapUIControlsButton", "DapUIControlsDisabled", "DapUIFloatNormal" },
    { bg = COLOR_BACKGROUND_PRIMARY })

hl({
    "BlinkCmpMenu",
    "BlinkCmpDoc",
    "BlinkCmpSignatureHelp",
}, { bg = COLOR_BACKGROUND_PRIMARY, force = true })

hl({
    "BlinkCmpDocBorder",
    "BlinkCmpSignatureHelpBorder",
}, { fg = COLOR_BORDER, bg = COLOR_BACKGROUND_PRIMARY, force = true })

hl({ "MasonHeader", "MasonHeaderSecondary" }, { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "MasonHighlightBlockBold", { fg = COLOR_MASON_HIGHLIGHT, force = true })
set(0, "MasonMutedBlock", { fg = COLOR_MASON_MUTED, force = true })

set(0, "@square_bracket", { fg = "#3d59a1", bold = true, force = true })
set(0, "BlinkCmpSignatureActiveParameter", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "@module.python", { link = "@type.python" })
set(0, "@keyword.import.python", { link = "@keyword.conditional.python" })
set(0, "@keyword.import.rust", { link = "@keyword.conditional.python" })
set(0, "@lsp.type.namespace.python", { link = "@module.python" })
set(0, "@lsp.type.variable", { fg = COLOR_LSP_TYPE_VARIABLE })
set(0, "@variable", { fg = COLOR_LSP_TYPE_VARIABLE })
set(0, "@lsp.type.macro.cpp", { fg = COLOR_LSP_TYPE_MACRO_CPP })
set(0, "GrugFarResultsMatch", { link = "@type.builtin.cpp" })

set(0, "RenderMarkdownCode", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "RenderMarkdownCodeInline", { bg = COLOR_BACKGROUND_PRIMARY, force = true })

set(0, "ToggleTerm1FloatBorder", { bg = COLOR_BACKGROUND_PRIMARY, fg = COLOR_BORDER, force = true })
set(0, "ToggleTerm2FloatBorder", { bg = COLOR_BACKGROUND_PRIMARY, fg = COLOR_BORDER, force = true })
set(0, "LspReferenceRead", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "PmenuKind", { bg = COLOR_GENERAL_NONE, force = true })
set(0, "@conceal", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "BufferLineBuffer", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
set(0, "Substitute", { link = "SubstituteRange" })
set(0, "@punctuation.bracket", { fg = "#ff9e64" })
set(0, "@module.haskell", { link = "@type.haskell" })

vim.cmd.highlight("MyTerminalBorder guifg=" .. COLOR_BACKGROUND_PRIMARY)

vim.opt.guicursor = GUICURSOR_DEFAULT

local keyword = vim.api.nvim_get_hl(0, { name = "@keyword" })
keyword.bold = true
---@diagnostic disable-next-line: param-type-mismatch
set(0, "@keyword", keyword)

local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
comment.italic = true
comment.bold = false
---@diagnostic disable-next-line: param-type-mismatch
set(0, "Comment", comment)

set(0, "@io.cout", { fg = "#f7768e" })
set(0, "@io.cin", { fg = "#f7768e" })
set(0, "@io.endl", { fg = "#ff9e64" })
set(0, "LspInfoBorder", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
