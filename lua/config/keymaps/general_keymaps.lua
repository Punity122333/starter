-- General Keymaps
vim.keymap.set("n", "<leader>rb", "<cmd>edit!<cr>", { desc = "Refresh Buffer" })
vim.keymap.set("v", ">", function()
  local saved = vim.o.lazyredraw
  vim.o.lazyredraw = true
  vim.cmd("normal! >")
  vim.cmd("normal! gv")
  vim.o.lazyredraw = saved
end, { noremap = true, silent = true, desc = "Indent and reselect" })

vim.keymap.set("v", ">", function()
	local saved = vim.o.lazyredraw
	vim.o.lazyredraw = true
	vim.cmd("normal! >")
	vim.cmd("normal! gv")
	vim.o.lazyredraw = saved
end, { noremap = true, silent = true, desc = "Indent and reselect" })

vim.keymap.set("v", "<", function()
	local saved = vim.o.lazyredraw
	vim.o.lazyredraw = true
	vim.cmd("normal! <")
	vim.cmd("normal! gv")
	vim.o.lazyredraw = saved
end, { noremap = true, silent = true, desc = "Unindent and reselect" })

vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left", silent = true })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down", silent = true })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up", silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right", silent = true })
