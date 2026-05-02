local M = {}

local colors = {
    bg_primary = "#1a1b26",
    bg_selection = "#28344a",
    fg_bold = "#ff9e64",
    unused_diag = "#6c7086",
    cursor_fg = "#000000",
    cursor_bg = "#00ff00",
}

function M.setup()
    local apply = require("theme.apply").apply

    vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        group = vim.api.nvim_create_augroup("ThemeGodMode", { clear = true }),
        callback = function()
            apply(colors)
        end,
    })

    apply(colors)
end

return M
