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
  Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal Vertical (Right)" })
vim.keymap.set("n", "<leader>fV", function()
  Snacks.terminal(nil, { win = { position = "left", width = 0.4 } })
end, { desc = "Terminal Vertical (Left)" })
vim.keymap.set("n", "<leader>ti", ":lua require('image').toggle()<CR>", { desc = "Toggle Images" })
vim.keymap.set("n", "<leader>br", function()
  Snacks.bufdelete()
end, { desc = "Remove Current Buffer" })
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
vim.keymap.set("n", "<leader>pv_pdf", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

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
