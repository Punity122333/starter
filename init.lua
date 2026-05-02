local FLAG_FORCE_ALL = os.getenv("NO_LAZY") == "1"

if vim.loader then
    vim.loader.enable()
end

require("core.env").setup()
require("core.options")

require("patches.treesitter").setup()
require("patches.render_markdown").setup()
require("patches.notify").setup()

require("config.lazy")
require("config.highlights")

require("theme").setup()
require("core.commands")

vim.defer_fn(function()
    pcall(require, "lspconfig")
    local ft = vim.bo.filetype
    if not FLAG_FORCE_ALL and ft ~= "" and ft ~= "lazy" and ft ~= "dashboard" then
        vim.cmd("doautocmd BufEnter")
    end
end, 300)
