local function toggle_lazygit()
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    lazygit:toggle()
end

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>t<Up>", "<cmd>ToggleTerm direction=horizontal<cr>", opts)
vim.keymap.set("n", "<leader>t<Down>", "<cmd>ToggleTerm direction=horizontal<cr>", opts)
vim.keymap.set("n", "<leader>t<Left>", "<cmd>ToggleTerm direction=vertical<cr>", opts)
vim.keymap.set("n", "<leader>t<Right>", "<cmd>ToggleTerm direction=vertical<cr>", opts)

vim.keymap.set("n", "<leader>\\", toggle_lazygit, { desc = "ToggleTerm Lazygit" })
vim.keymap.set("n", "<leader>gg", toggle_lazygit, { desc = "ToggleTerm Lazygit" })
vim.keymap.set("n", "<leader>gG", toggle_lazygit, { desc = "ToggleTerm Lazygit" })

vim.keymap.set("n", "<leader>fv", function()
    Snacks.terminal(nil, { win = { position = "right", width = 0.25 } })
end, { desc = "Terminal Vertical (Right)" })

vim.keymap.set("n", "<leader>fV", function()
    Snacks.terminal(nil, { win = { position = "left", width = 0.25 } })
end, { desc = "Terminal Vertical (Left)" })

vim.keymap.set("n", "<leader>Pv", "<cmd>vsplit | term<cr>a", { desc = "Terminal Vertical Split" })
vim.keymap.set("n", "<leader>Ph", "<cmd>split | term<cr>a", { desc = "Terminal Horizontal Split" })
