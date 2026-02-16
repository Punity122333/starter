---@diagnostic disable: undefined-global
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom :wq that properly sequences save -> cleanup -> exit
vim.api.nvim_create_user_command("WQ", function()
  -- 1. Save all buffers
  vim.cmd("silent! wall")
  
  -- 2. Wait a bit for autosave/persistence to finish
  vim.defer_fn(function()
    -- 3. Stop any autosave timers
    local ok_autosave, autosave = pcall(require, "auto-save")
    if ok_autosave and autosave then
      -- Disable autosave before quitting
      vim.g.auto_save_abort = true
    end
    
    -- 4. Save session if persistence is enabled
    local ok_persist, persistence = pcall(require, "persistence")
    if ok_persist and persistence then
      persistence.save()
    end
    
    -- 5. Wait for everything to complete, then quit
    vim.defer_fn(function()
      vim.cmd("qall!")
    end, 100)
  end, 150)
end, { desc = "Save all and quit cleanly" })

-- Create lowercase version too
vim.api.nvim_create_user_command("Wq", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly" })

-- Create :wqa variant
vim.api.nvim_create_user_command("WQA", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly" })

vim.api.nvim_create_user_command("Wqa", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly" })

-- Override the default :wq to use our custom version
vim.api.nvim_create_user_command("Wq", function()
  vim.cmd("WQ")
end, { desc = "Save all and quit cleanly", force = true })

-- Create command abbreviations so :wq automatically uses our custom version
vim.cmd([[
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "WQ" : "wq"
  cnoreabbrev <expr> Wq getcmdtype() == ":" && getcmdline() == "Wq" ? "WQ" : "Wq"
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == "wqa" ? "WQA" : "wqa"
  cnoreabbrev <expr> Wqa getcmdtype() == ":" && getcmdline() == "Wqa" ? "WQA" : "Wqa"
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == "wqa" ? "WQA" : "wqa"
]])

-- Force Enter to behave normally and stop the double-tap
vim.keymap.set("i", "<CR>", "<CR>", { noremap = true })
-- Force Backspace to be just one backspace
vim.keymap.set("i", "<BS>", "<BS>", { noremap = true })

-- Vertical Terminal Splits (Snacks)
vim.keymap.set("n", "<leader>fv", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal Vertical (Right)" })
vim.keymap.set("n", "<leader>fV", function()
  Snacks.terminal(nil, { win = { position = "left", width = 0.4 } })
end, { desc = "Terminal Vertical (Left)" })
-- Toggle images
vim.keymap.set("n", "<leader>ti", ":lua require('image').toggle()<CR>", { desc = "Toggle Images" })
-- 1. Insert Mode Navigation (The "Easy Access" Layer)
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right" })

-- 2. Line Bubbling (The "Heavy Lifting" Layer)
-- Move lines up and down in Normal Mode
vim.keymap.set("n", "<A-S-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-S-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Move lines up and down in Insert Mode
vim.keymap.set("i", "<A-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

-- Move blocks in Visual Mode
vim.keymap.set("v", "<A-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "<A-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move block up" })
vim.keymap.set("n", "<leader>br", function() Snacks.bufdelete() end, { desc = "Remove Current Buffer" })
vim.keymap.set("n", "<leader>pv", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- NOTE: asm_lsp is disabled in lsp.lua to avoid bogus diagnostics
-- If you need LSP features for assembly, uncomment the asm_lsp config in lua/plugins/lsp.lua
-- and uncomment the toggle below

-- -- Global state for the toggle
-- _G.asm_dialect_mode = "standard"
-- 
-- vim.keymap.set("n", "<leader>pA", function()
--   local clients = vim.lsp.get_clients({ name = "asm_lsp" })
--   
--   -- Flip the state
--   if _G.asm_dialect_mode == "standard" then
--     _G.asm_dialect_mode = "nasm_16"
--   else
--     _G.asm_dialect_mode = "standard"
--   end
-- 
--   for _, client in ipairs(clients) do
--     if _G.asm_dialect_mode == "nasm_16" then
--       client.config.settings = {
--         assembler = "nasm",
--         instruction_set = "x86",
--         mode = "16bit"
--       }
--       print("LSP Dialect: 16-BIT NASM (Bootloader Mode)")
--     else
--       client.config.settings = {
--         assembler = "gas",
--         instruction_set = "x86_64",
--         mode = "64bit"
--       }
--       print("LSP Dialect: STANDARD (64-bit GAS)")
--     end
--     
--     -- Force the restart to apply settings
--     vim.cmd("LspRestart asm_lsp")
--   end
-- end, { desc = "Toggle ASM Dialect (16-bit NASM / 64-bit GAS)" })