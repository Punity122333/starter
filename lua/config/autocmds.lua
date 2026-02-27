-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Add this to a file in /lua/config/autocmds.lua
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#565f89", bg = "none" }) -- Subtle grey numbers
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "none", bg = "none" }) -- Hides the '~' at the bottom

-- Smart codeAction heartbeat - only for LSPs that support it
local codeaction_timer = nil
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- Force UTF-16 offset encoding for all clients to prevent conflicts
    if client.offset_encoding then
      client.offset_encoding = "utf-16"
    end

    -- Only run for LSPs that explicitly support codeAction
    local supports_code_action = client.server_capabilities.codeActionProvider
    if not supports_code_action then
      return
    end

    -- Excluded servers that spam or cause issues
    local excluded_servers = { "html", "cssls", "eslint" }
    for _, name in ipairs(excluded_servers) do
      if client.name == name then
        return
      end
    end

    -- Start a buffer-local heartbeat for this LSP
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = args.buf,
      callback = function()
        if codeaction_timer then
          vim.fn.timer_stop(codeaction_timer)
        end

        codeaction_timer = vim.fn.timer_start(300, function()
          -- Fix: Add position_encoding parameter
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

          vim.lsp.buf_request(args.buf, "textDocument/codeAction", params, function(err, result, ctx, config)
            -- Silent success - just keep the connection alive
          end)
        end)
      end,
    })
  end,
})
