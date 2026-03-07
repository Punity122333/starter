vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#565f89", bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "none", bg = "none" })

local codeaction_timer = nil
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.offset_encoding then
      client.offset_encoding = "utf-16"
    end

    local supports_code_action = client.server_capabilities.codeActionProvider
    if not supports_code_action then
      return
    end

    local excluded_servers = { "html", "cssls", "eslint" }
    for _, name in ipairs(excluded_servers) do
      if client.name == name then
        return
      end
    end

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = args.buf,
      callback = function()
        if codeaction_timer then
          vim.fn.timer_stop(codeaction_timer)
        end

        codeaction_timer = vim.fn.timer_start(300, function()
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

          vim.lsp.buf_request(args.buf, "textDocument/codeAction", params, function(err, result, ctx, config)
          end)
        end)
      end,
    })
  end,
})