vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })

vim.keymap.set("n", "H", "H", { desc = "Move to top of screen" })
vim.keymap.set("n", "L", "L", { desc = "Move to bottom of screen" })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left", silent = true })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down", silent = true })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up", silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right", silent = true })

vim.keymap.set("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
