local M = {}

function M.setup()
    local home = vim.fn.expand("~")

    vim.env.PATH = table.concat({
        home .. "/.npm-global/bin",
        home .. "/.local/bin",
        home .. "/.local/share/nvim/mason/bin",
        vim.env.PATH,
    }, ":")

    local lr = home .. "/.luarocks"
    package.path = package.path .. ";" .. lr .. "/share/lua/5.1/?/init.lua;" .. lr .. "/share/lua/5.1/?.lua;"
    package.cpath = package.cpath .. ";" .. lr .. "/lib/lua/5.1/?.so;"
end

return M
