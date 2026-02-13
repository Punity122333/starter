return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        update_in_insert = true, -- Enable updates in insert mode
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        underline = true,
        severity_sort = true,
        -- 500ms delay for diagnostics in insert mode
        float = {
          border = "rounded",
          source = "always",
        },
      },
    },
    config = function(_, opts)
      -- Apply the diagnostics configuration with 500ms delay
      vim.diagnostic.config(vim.tbl_extend("force", opts.diagnostics or {}, {
        update_in_insert = false, -- Disable automatic updates in insert mode
      }))

      -- Create a debounced diagnostic update for insert mode
      local diagnostic_timer = nil

      vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
        group = vim.api.nvim_create_augroup("DiagnosticDelay", { clear = true }),
        callback = function()
          -- Cancel existing timer
          if diagnostic_timer then
            vim.fn.timer_stop(diagnostic_timer)
          end

          -- Set new timer for 500ms delay
          diagnostic_timer = vim.fn.timer_start(500, function()
            vim.schedule(function()
              -- Trigger LSP to update diagnostics for current buffer
              local bufnr = vim.api.nvim_get_current_buf()
              if vim.api.nvim_buf_is_valid(bufnr) then
                -- This forces the LSP client to send updated diagnostics
                vim.diagnostic.reset(nil, bufnr)

                -- Request fresh diagnostics from LSP
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                  if client.server_capabilities.diagnosticProvider then
                    vim.lsp.buf.document_diagnostics(bufnr, client.id)
                  end
                end
              end
            end)
          end)
        end,
      })

      -- On leaving insert mode, update diagnostics immediately
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = vim.api.nvim_create_augroup("DiagnosticImmediateUpdate", { clear = true }),
        callback = function()
          if diagnostic_timer then
            vim.fn.timer_stop(diagnostic_timer)
            diagnostic_timer = nil
          end
          -- Force immediate diagnostic refresh
          local bufnr = vim.api.nvim_get_current_buf()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.reset(nil, bufnr)
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              if client.server_capabilities.diagnosticProvider then
                vim.lsp.buf.document_diagnostics(bufnr, client.id)
              end
            end
          end
        end,
      })
    end,
  }, -- Configure snacks.nvim
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false }, -- Disables smooth scrolling
    },
  },

  {
    "nvim-mini/mini.animate",
    enabled = false,
  },
}
