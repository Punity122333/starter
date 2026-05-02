local M = {}

M.PROTECTED_PATTERNS = {
    "Border",
    "Prompt",
    "Visual",
    "CursorLine",
    "Search",
    "Pmenu",
    "Cmp",
    "Blink",
    "Float",
    "Kind",
    "Menu",
    "Wild",
    "Noice",
    "Lsp",
    "LSP",
    "lsp",
    "Msg",
    "Diagnostic",
    "lualine",
    "StatusLine",
    "Completion",
    "completion",
    "snippet",
    "Snippet",
    "NormalFloat",
    "Muted",
    "Text",
    "Avante",
    "Ask",
    "VM",
    "Rainbow",
    "LazyReason",
    "TroubleCounts",
    "GitSign",
    "Dap",
}

M.SELECTION_NAMES = { SnacksPickerCursorLine = true, TelescopeSelection = true, CursorLine = true }

function M.is_protected(name)
    for _, p in ipairs(M.PROTECTED_PATTERNS) do
        if name:find(p, 1, true) then
            return true
        end
    end
    return false
end

function M.is_selection(name)
    if M.SELECTION_NAMES[name] then
        return true
    end

    return name:find("Selected", 1, true)
        and (name:find("SnacksPicker", 1, true) or name:find("Telescope", 1, true))
end

function M.wants_none_bg(name)
    return name:find("BlinkCmpKind", 1, true)
        or name:find("Profiler", 1, true)
        or name:find("Benchmark", 1, true)
        or (name:find("SnacksPicker", 1, true) and not name:find("Selected", 1, true))
end

return M
