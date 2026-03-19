local COMMAND_SAVE_AND_QUIT = "WQ"
local COMMAND_SAVE_AND_QUIT_ALT1 = "Wq"
local COMMAND_SAVE_AND_QUIT_ALL = "WQA"
local COMMAND_SAVE_AND_QUIT_ALL_ALT1 = "Wqa"

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT, function()
  vim.cmd("silent! wall")
  vim.defer_fn(function()
    local ok_autosave, autosave = pcall(require, "auto-save")
    if ok_autosave and autosave then
      vim.g.auto_save_abort = true
    end
    local ok_persist, persistence = pcall(require, "persistence")
    if ok_persist and persistence then
      persistence.save()
    end
    vim.defer_fn(function()
      vim.cmd("qall!")
    end, 100)
  end, 150)
end, { desc = "Save all and quit cleanly" })

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALT1, function()
  vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly", force = true })
vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALL, function()
  vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly" })
vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALL_ALT1, function()
  vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly" })

vim.cmd([[ 
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "WQ" : "wq"
  cnoreabbrev <expr> Wq getcmdtype() == ":" && getcmdline() == "Wq" ? "WQ" : "Wq"
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == "wqa" ? "WQA" : "wqa"
  cnoreabbrev <expr> Wqa getcmdtype() == ":" && getcmdline() == "Wqa" ? "WQA" : "Wqa"
]])

vim.keymap.set("i", "<CR>", "<CR>", { noremap = true })
vim.keymap.set("i", "<BS>", "<BS>", { noremap = true })

vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left", silent = true })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down", silent = true })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up", silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right", silent = true })

vim.keymap.set("n", "<leader>fv", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.25 } })
end, { desc = "Terminal Vertical (Right)" })
vim.keymap.set("n", "<leader>fV", function()
  Snacks.terminal(nil, { win = { position = "left", width = 0.25 } })
end, { desc = "Terminal Vertical (Left)" })
vim.keymap.set("n", "<leader>ti", ":lua require('image').toggle()<CR>", { desc = "Toggle Images" })
vim.keymap.set("n", "<leader>br", function()
  Snacks.bufdelete()
end, { desc = "Remove Current Buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })

vim.keymap.set("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

vim.keymap.set("n", "<leader>fD", function()
  Snacks.picker.files({
    cwd = vim.fn.expand("~"),
    hidden = true,
    ignored = false,
    title = "Home Search",
    exclude = { "node_modules", ".git", ".cache", "__pycache__", ".venv", "venv", "build", "dist" },
  })
end, { desc = "Search Home" })

vim.keymap.set("n", "<leader>sD", function()
  Snacks.picker.grep({
    cwd = vim.fn.expand("~"),
    title = "Grep Home (Filtered)",
    hidden = true,
    ignored = false,
    exclude = { "node_modules", ".git", ".cache", "__pycache__", ".venv", "venv", "build", "dist", "*.lock" },
  })
end, { desc = "Grep Home Directory" })

vim.keymap.set("n", "<leader>fx", function()
  Snacks.explorer.reveal()
end, { desc = "Reveal Current File in Explorer" })
vim.keymap.del("n", "<leader>gg")

vim.keymap.set("n", "<leader>pv", "<cmd>vsplit | term<cr>a", { desc = "Terminal Vertical Split" })
vim.keymap.set("n", "<leader>ph", "<cmd>split | term<cr>a", { desc = "Terminal Horizontal Split" })
vim.keymap.set("n", "<leader>pdf", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

vim.keymap.set("n", "<leader>uN", function()
  local rn = not vim.wo.relativenumber
  vim.wo.relativenumber = rn
  vim.notify(rn and "Relative numbers" or "Absolute numbers", vim.log.levels.INFO)
end, { desc = "Toggle relative/absolute line numbers" })

vim.api.nvim_create_user_command("TSRestart", function()
  local buf = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  if lang then
    vim.treesitter.stop(buf)
    vim.treesitter.start(buf, lang)
    vim.notify("Treesitter restarted for: " .. lang, vim.log.levels.INFO)
  else
    vim.notify("No Treesitter parser for this filetype", vim.log.levels.WARN)
  end
end, { desc = "Restart Treesitter for current buffer" })

local function wrap_saga(cmd)
  return function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(bufnr, false, {
      relative = 'editor', width = 1, height = 1, row = 0, col = 0, style = 'minimal'
    })
    vim.cmd("silent! " .. cmd)
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, 50)
  end
end

vim.keymap.set("n", "gh", wrap_saga("Lspsaga finder"), { desc = "LSP Finder" })
vim.keymap.set("n", "K", wrap_saga("Lspsaga hover_doc"), { desc = "Hover Docs" })
vim.keymap.set("n", "gjd", wrap_saga("Lspsaga goto_definition"), { desc = "Goto Definition" })
vim.keymap.set("n", "gjt", wrap_saga("Lspsaga peek_type_definition"), { desc = "Peek Type Definition" })
vim.keymap.set("n", "gji", wrap_saga("Lspsaga incoming_calls"), { desc = "Incoming Calls" })
vim.keymap.set("n", "gjo", wrap_saga("Lspsaga outgoing_calls"), { desc = "Outgoing Calls" })
vim.keymap.set("n", "gjn", wrap_saga("Lspsaga diagnostic_jump_next"), { desc = "Next Diagnostic" })
vim.keymap.set("n", "gjp", wrap_saga("Lspsaga diagnostic_jump_prev"), { desc = "Prev Diagnostic" })

vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "LSP Outline" })
vim.keymap.set("n", "gjs", "<cmd>Lspsaga outline<CR>", { desc = "Toggle Outline" })
vim.keymap.set("n", "gjb", "<cmd>Lspsaga symbols_in_winbar<CR>", { desc = "Winbar Symbols" })
vim.keymap.set("n", "gjl", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagnostics" })

require("which-key").add({ { "gj", group = "LSP Navigation" } })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })
vim.keymap.set("n", "<leader>[]", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id, true)
  end
  vim.cmd("edit!")
  vim.notify("LSP Clients refreshed for buffer", vim.log.levels.INFO, { title = "LSP Panic" })
end, { desc = "LSP Panic Button (Soft Refresh)" })
vim.keymap.set("n", "<leader>sf", function()
  local grug = require("grug-far")
  grug.open({
    transient = true,
    prefills = {
      paths = vim.fn.expand("%"),
    },
  })
end, { desc = "Grug Far: Current File" })
vim.keymap.set("n", "<leader>md", "dm<leader>", { desc = "Clear all marks" })
vim.keymap.set("n", "<leader>ml", "dm<leader>", { desc = "Clear local marks" })

vim.keymap.set("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Format file manually" })
vim.keymap.set('n', '<leader>mb', ':set list!<CR>', { noremap = true, silent = true, desc = 'Toggle listchars' })
vim.keymap.set("i", "<C-f>", "<C-t>", { desc = "Indent line" })
vim.keymap.set("n", "S", function()
  require("flash").treesitter({
    search = { multi_window = false, wrap = true },
    jump = { pos = "start" },
    action = function(match)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
    end,
    label = { before = true, after = false },
  })
end, { desc = "Global Treesitter Jump" })
vim.keymap.set({"n", "x", "o"}, "<leader>]", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter Visual Selection" })
vim.keymap.set("n", "<leader>uH", function()
  vim.opt.list = not vim.opt.list:get()
  local status = vim.opt.list:get() and "Enabled" or "Disabled"
  vim.notify("Hidden Characters " .. status, vim.log.levels.INFO, {
    title = "UI Toggle",
  })
end, { desc = "Toggle List / NoList" })
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<cr>", { desc = "ToggleTerm Lazygit" })
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>t<Up>', '<cmd>ToggleTerm direction=horizontal<cr>', opts)
vim.keymap.set('n', '<leader>t<Down>', '<cmd>ToggleTerm direction=horizontal<cr>', opts)

vim.keymap.set('n', '<leader>t<Left>', '<cmd>ToggleTerm direction=vertical<cr>', opts)
vim.keymap.set('n', '<leader>t<Right>', '<cmd>ToggleTerm direction=vertical<cr>', opts)

pcall(vim.keymap.del, "n", "<leader>sb")
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Search Current Buffer" })
