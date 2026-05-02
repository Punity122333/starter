local utils = require("theme.utils")
local static = require("theme.static")

local M = {}

function M.apply(colors)
    local set = vim.api.nvim_set_hl

    for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
        if not hl.bg then
            goto continue
        end

        if utils.is_selection(name) then
            set(0, name, { bg = colors.bg_selection, fg = hl.fg, force = true })
            goto continue
        end

        if name:find("^@markup") or name:find("^@markdown") or name:find("^@conceal") or name:find("^@spell") then
            set(0, name, { bg = "NONE", fg = hl.fg, bold = true, force = true })
            goto continue
        end

        if utils.is_protected(name) then
            goto continue
        end

        set(0, name, {
            bg = utils.wants_none_bg(name) and "NONE" or colors.bg_primary,
            fg = hl.fg,
            blend = 0,
            force = true,
        })

        ::continue::
    end

    for _, g in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
        local existing = vim.api.nvim_get_hl(0, { name = "DiagnosticUnderline" .. g })
        set(0, "DiagnosticUnderline" .. g, { sp = existing.sp, underline = true, bg = "NONE", force = true })
    end

    local static_hls = static.get(colors)
    for name, spec in pairs(static_hls) do
        set(0, name, spec)
    end
end

return M
