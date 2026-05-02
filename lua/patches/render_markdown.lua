local M = {}

function M.setup()
    local ok, rm = pcall(require, "render-markdown")
    if not ok then
        return
    end

    local orig = rm.attach

    rm.attach = function(buf)
        buf = buf or vim.api.nvim_get_current_buf()

        if not vim.bo[buf].filetype:match("^snacks_") then
            orig(buf)
        end
    end
end

return M
