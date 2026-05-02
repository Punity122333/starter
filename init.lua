local FLAG_FORCE_ALL = os.getenv("NO_LAZY") == "1"

if vim.loader then
    vim.loader.enable()
end

require("core")

require("patches.treesitter").setup()
require("patches.render_markdown").setup()
require("patches.notify").setup()

require("modules.system.lazy")
require("modules.ui")

require("theme").setup()
require("modules.system")

vim.defer_fn(function()
    pcall(require, "lspconfig")
    local ft = vim.bo.filetype
    if not FLAG_FORCE_ALL and ft ~= "" and ft ~= "lazy" and ft ~= "dashboard" then
        vim.cmd("doautocmd BufEnter")
    end
end, 300)
