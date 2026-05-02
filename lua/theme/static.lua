local M = {}

function M.get(colors)
    return {
        SnacksPickerSelected = { bg = "NONE", fg = "#27a1b9", force = true },
        SnacksPickerUnselected = { bg = "NONE", force = true },

        Cursor = { fg = colors.cursor_fg, bg = colors.cursor_bg, bold = true },
        CursorInsert = { fg = colors.cursor_fg, bg = colors.cursor_bg },

        DiagnosticUnnecessary = { fg = colors.unused_diag, strikethrough = true, force = true },

        LspReferenceText = { bg = colors.bg_selection, force = true },
        LspReferenceRead = { bg = "NONE", force = true },
        LspReferenceWrite = { bg = "NONE", force = true },

        MarkdownBold = { fg = colors.fg_bold, bold = true, force = true },
        ["@markup.strong"] = { fg = colors.fg_bold, bold = true, force = true },

        BlinkCmpKindFile = { bg = "NONE", force = true },
        LspKindFile = { bg = "NONE", force = true },
        BlinkCmpSignatureHelpBorder = { fg = "#27a1b9", bg = colors.bg_primary, force = true },
        BlinkCmpSignatureHelp = { bg = colors.bg_primary, force = true },
        BlinkCmpSignatureActiveParameter = { bg = colors.bg_primary, force = true },

        StatusLine = { bg = "#16161e", force = true },
        StatusLineNC = { bg = "#16161e", force = true },

        RgPreviewLine = { bg = "#7aa2f7", fg = "#1a1b26", bold = true },
        RgPreviewLineCur = { bg = "#e07840", fg = "#1a1b26", bold = true },
        SnacksBackdrop = { bg = "#1a1b26", blend = 0, force = true },

        MiniSnippetsCurrent = { blend = 100 },
        MiniSnippetsVisited = { blend = 100 },
        MiniSnippetsUnvisited = { blend = 100 },

        NavPreviewLine = { bg = colors.bg_primary, force = true },
    }
end

return M
