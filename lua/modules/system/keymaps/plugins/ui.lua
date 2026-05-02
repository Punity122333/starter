vim.keymap.set("n", "<leader>uN", function()
    local rn = not vim.wo.relativenumber
    vim.wo.relativenumber = rn
    vim.notify(rn and "Relative numbers" or "Absolute numbers", vim.log.levels.INFO)
end, { desc = "Toggle relative/absolute line numbers" })

vim.keymap.set("n", "<leader>uH", function()
    vim.opt.list = not vim.opt.list:get()
    vim.notify(
        vim.opt.list:get() and "Hidden chars enabled" or "Hidden chars disabled",
        vim.log.levels.INFO,
        { title = "UI Toggle" }
    )
end, { desc = "Toggle List / NoList" })

vim.keymap.set("n", "<leader>mb", ":set list!<CR>", { noremap = true, silent = true, desc = "Toggle listchars" })

vim.keymap.set("n", "<leader>uj", function()
    local img = require("snacks.image")
    local buf = vim.api.nvim_get_current_buf()
    local new_val = not img.config.doc.float

    Snacks.config.image.doc.float = new_val
    img.config.doc.float = new_val

    if new_val then
        vim.b[buf].snacks_image_attached = false
        img.doc._attach(buf)
    else
        img.doc.hover_close()
        pcall(vim.api.nvim_del_augroup_by_name, "snacks.image.doc." .. buf)
    end

    vim.notify("Hover images: " .. (new_val and "ON" or "OFF"))
end, { desc = "Toggle hover image previews" })
