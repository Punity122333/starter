vim.keymap.set("n", "<leader>Po", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })

vim.keymap.set("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Format file manually" })

vim.keymap.set("i", "<C-S-k>", function()
    require("avante.suggestion").show({})
end, { desc = "Manual Avante suggestion" })

vim.keymap.set("n", "<C-q>", function()
    require("case-dial").dial_normal()
end, { desc = "Dial Case" })
vim.keymap.set("v", "<C-q>", function()
    require("case-dial").dial_visual()
end, { desc = "Dial Case" })

vim.keymap.set("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
    vim.cmd("redraw!")
end)

vim.keymap.set({ "i", "s" }, "<C-Tab>", function()
    if vim.snippet and vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
        return
    end
end, { silent = true })
