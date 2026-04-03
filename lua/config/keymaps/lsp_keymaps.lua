-- LSP Keymaps
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
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

