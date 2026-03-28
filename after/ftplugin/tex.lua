vim.opt_local.smartindent = false
vim.opt_local.autoindent  = false

vim.opt_local.indentexpr  = "vimtex#indent#do(v:lnum)"

vim.opt_local.shiftwidth  = 4
vim.opt_local.tabstop     = 4
vim.opt_local.expandtab   = true

vim.keymap.set("n", "<leader>cl", "gg=G<C-o>", { buffer = true, desc = "Fix LaTeX Indent" })

vim.keymap.set("i", "<C-=>", "<plug>(vimtex-delim-close)",
    { buffer = true, silent = true, desc = "VimTeX: Close delimiter/env" })
