vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.concealcursor = ""
vim.g.VM_THEME = ""
vim.g.VM_SET_STATUSLINE = 0

if vim.fn.has("wayland") == 1 then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
        paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
        cache_enabled = 1,
    }
end

vim.filetype.add({ extension = { regex = "regex" } })

vim.opt.formatoptions:remove({ "o", "r" })
vim.opt.paste = false
vim.opt.autoindent = false
vim.opt.smartindent = false
vim.opt.cindent = false
