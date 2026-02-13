return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    return {
      completion = {
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          auto_show = true,
        },
      },
      
      snippets = {
        preset = "default", -- Use blink's built-in snippet expansion
      },
      keymap = {
        preset = "default",
        -- THE FIX: Enter only accepts if you explicitly selected something
        -- Otherwise it just inserts a newline like a normal editor
        ["<S-CR>"] = { "accept", "fallback" },
        -- Smart Tab: Copilot > Snippet > Completion > indent fallback
        ["<Tab>"] = {
          function(cmp)
            -- Check if Copilot suggestion is visible
            local copilot_ok, copilot = pcall(require, "copilot.suggestion")
            if copilot_ok and copilot.is_visible() then
              copilot.accept()
              return true
            end
            
            -- Try snippet navigation first
            if cmp.snippet_forward() then
              return true
            end
            
            -- Try completion selection
            if cmp.select_next() then
              return true
            end
            
            -- Fallback: Insert actual tab/indent
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            return true
          end,
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            max_items = 25, -- Limit LSP completions to 25 items
            timeout_ms = 700, -- Faster timeout for LSP
          },
          buffer = {
            max_items = 25,
          },
          snippets = {
            max_items = 25,
          },
          path = {
            max_items = 25,
          },
        },
      },
      
    }
  end,
}
