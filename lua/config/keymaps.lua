local current_model = "claude-haiku-4.5"

local function toggle_avante_model()
  local ok, avante = pcall(require, "avante")
  if not ok then
    return
  end

  current_model = (current_model == "claude-haiku-4.5") and "claude-4.6-sonnet" or "claude-haiku-4.5"

  avante.setup({
    provider = "copilot",
    providers = {
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = current_model,
        proxy = nil,
        allow_insecure_call = true,
        timeout = 30000,
        extra_request_body = {
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
  })

  vim.notify("Avante Copilot Model: " .. current_model, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("WQ", function()
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

vim.api.nvim_create_user_command("Wq", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly", force = true })
vim.api.nvim_create_user_command("WQA", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly" })
vim.api.nvim_create_user_command("Wqa", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly" })

vim.cmd([[ 
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "WQ" : "wq"
  cnoreabbrev <expr> Wq getcmdtype() == ":" && getcmdline() == "Wq" ? "WQ" : "Wq"
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == "wqa" ? "WQA" : "wqa"
  cnoreabbrev <expr> Wqa getcmdtype() == ":" && getcmdline() == "Wqa" ? "WQA" : "Wqa"
]])

vim.keymap.set("i", "<CR>", "<CR>", { noremap = true })
vim.keymap.set("i", "<BS>", "<BS>", { noremap = true })
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })

-- Line/Block Movement
vim.keymap.set("n", "<A-S-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-S-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "<A-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move block up" })

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
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

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
vim.keymap.set("n", "<leader>pvpdf", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })

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

vim.keymap.set("n", "<leader>am", toggle_avante_model, { desc = "avante: toggle copilot model" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "avante", "avante-input" },
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>am",
      toggle_avante_model,
      { buffer = true, desc = "avante: toggle copilot model (buffer local)" }
    )
  end,
})
-- Peek Definition (Opens a floating window)
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })

-- Finder (See definition and references in one split UI)
vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP Finder" })

-- Outline (See all your functions/structs in a side bar)
vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "LSP Outline" })

-- Hover Doc (Better than the default K)
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Docs" })
-- Register the group name so Which-Key looks clean
require("which-key").add({ { "gj", group = "LSP Navigation" } })
-- Search in current buffer (lines/fuzziness)
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })

-- Search LSP Symbols (classes, functions, variables)
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
-- Navigation & Hierarchy (The three-letter combos)
vim.keymap.set("n", "gjd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Goto Definition" })
vim.keymap.set("n", "gjt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek Type Definition" })
vim.keymap.set("n", "gji", "<cmd>Lspsaga incoming_calls<CR>", { desc = "Incoming Calls" })
vim.keymap.set("n", "gjo", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Outgoing Calls" })

-- Structure & Symbols
vim.keymap.set("n", "gjs", "<cmd>Lspsaga outline<CR>", { desc = "Toggle Outline" })
vim.keymap.set("n", "gjb", "<cmd>Lspsaga symbols_in_winbar<CR>", { desc = "Winbar Symbols" })

-- Diagnostics & Docs
vim.keymap.set("n", "gjh", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Doc" })
vim.keymap.set("n", "gjl", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "gjn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
vim.keymap.set("n", "gjp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Prev Diagnostic" })
-- Disable macro recording
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })
vim.keymap.set("n", "<leader>[]", function()
  -- 1. Stop all current LSP clients attached to this buffer
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id, true)
  end

  -- 2. Force a buffer reload to re-trigger attachment
  vim.cmd("edit!")

  vim.notify("LSP Clients refreshed for buffer", vim.log.levels.INFO, { title = "LSP Panic" })
end, { desc = "LSP Panic Button (Soft Refresh)" })