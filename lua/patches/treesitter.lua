local M = {}

function M.setup()
    local orig = vim.treesitter.start

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.treesitter.start = function(buf, lang)
        buf = buf or vim.api.nvim_get_current_buf()

        if vim.bo[buf].filetype:match("^snacks_") then
            vim.bo[buf].syntax = "on"
            return
        end

        orig(buf, lang)
    end
end

return M
