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
        preset = "default",
      },
      keymap = {
        preset = "default",
        ["<S-CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            local copilot_ok, copilot = pcall(require, "copilot.suggestion")
            if copilot_ok and copilot.is_visible() then
              copilot.accept()
              return true
            end

            if cmp.snippet_forward() then
              return true
            end

            if cmp.select_next() then
              return true
            end

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
            max_items = 25,
            timeout_ms = 700,
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
