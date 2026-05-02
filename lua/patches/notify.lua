local M = {}

function M.setup()
    local orig = vim.notify

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, level, opts)
        if type(msg) ~= "string" or not msg:find("Avante") then
            orig(msg, level, opts)
        end
    end
end

return M
