vim.g.load_doxygen_syntax = 1

return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts or {}, {
      enabled = function()
        return vim.b.blink_enabled ~= false and vim.bo.buftype ~= "prompt"
      end,
      completion = {
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        accept = { auto_brackets = { enabled = true } },
        menu = {
          auto_show = true,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            border = "none",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine",
          },
        },
      },
      signature = { enabled = false },
      keymap = {
        preset = "default",
        ["<Up>"] = { "fallback" },
        ["<Down>"] = { "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-Up>"] = { "select_prev", "fallback" },
        ["<C-Down>"] = { "select_next", "fallback" },
        ["<S-CR>"] = { "accept", "fallback" },
        ["C-y"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" }, -- next item
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-CR>"] = { "accept", "fallback" },
        ["<C-S-0>"] = {
          function()
            vim.lsp.buf.signature_help()
            return true
          end,
          "fallback",
        },
        ["<C-]>"] = {
          function()
            vim.lsp.buf.signature_help()
            return true
          end,
          "fallback",
        },
        ["<Tab>"] = {
          function(cmp)
            local copilot_ok, copilot = pcall(require, "copilot.suggestion")
            if copilot_ok and copilot.is_visible() then
              copilot.accept()
              return true
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            return true
          end,
        },
        ["<S-Tab>"] = { "fallback" },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
        providers = {
          lsp = { max_items = 25, timeout_ms = 700 },
          buffer = { max_items = 25 },
          path = { max_items = 25 },
        },
      },
    })
  end,
}
