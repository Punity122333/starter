return {
  "folke/noice.nvim",
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    lsp = {
      signature = {
        enabled = true,
        auto_open = {
          enabled = false,
        },
        border = {
          style = "rounded",
        },
      },
    },
    views = {
      popup = {
        border = {
          style = "rounded",
        },
        win_options = {
          winhighlight = {
            Normal = "NoicePopup",
            FloatBorder = "NoicePopupBorder",
          },
        },
      },
    },
    routes = {
      {
        filter = {
          any = {
            { find = "attempt to yield across C-call boundary" },
            { find = "languagetree.lua" },
            { find = "tree_sitter_markdown_parse_code_blocks" },
            { find = "semanticTokensProvider" },
            { find = "semantic_tokens.lua" },
            { find = "shared.lua" },
            { find = "Invalid window" },
            { find = "selected model" },
            { find = "Using previously selected model" },
            { find = "Using" },
            { find = "with warnings" },
            { find = "repo map" },
            { find = "lines indented" },
            { find = "lines moved" },
            { find = "nvim_buf_set_extmark" },
            { find = "rustaceanvim" },
            { find = "clipboard" },
            { find = "promise" },
          },
        },
        opts = { skip = true },
      },
    },
  },
  keys = {
    {
      "<C-;>",
      function()
        local function is_signature_open()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if ft == "lsp_signature" or ft == "noice" then
                return true
              end
            end
          end
          return false
        end
        local max_attempts = 3
        local attempts = 0
        vim.g._sig_open = not vim.g._sig_open
        if vim.g._sig_open then
          local timer = vim.loop.new_timer()
          local function try_open()
            attempts = attempts + 1
            if not is_signature_open() then
              vim.lsp.buf.signature_help()
              if attempts < max_attempts then
                timer:start(60, 0, vim.schedule_wrap(try_open))
              else
                timer:stop()
                timer:close()
              end
            else
              timer:stop()
              timer:close()
            end
          end
          try_open()
        else
          require("noice").cmd("dismiss")
        end
      end,
      mode = { "i", "n" },
      desc = "Toggle LSP Signature Help (robust)",
    },
    {
      "<C-,>",
      function()
        local function is_signature_open()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if ft == "lsp_signature" or ft == "noice" then
                return true
              end
            end
          end
          return false
        end
        local max_attempts = 3
        local attempts = 0
        vim.g._sig_open = not vim.g._sig_open
        if vim.g._sig_open then
          local timer = vim.loop.new_timer()
          local function try_open()
            attempts = attempts + 1
            if not is_signature_open() then
              vim.lsp.buf.signature_help()
              if attempts < max_attempts then
                timer:start(60, 0, vim.schedule_wrap(try_open))
              else
                timer:stop()
                timer:close()
              end
            else
              timer:stop()
              timer:close()
            end
          end
          try_open()
        else
          require("noice").cmd("dismiss")
        end
      end,
      mode = { "i", "n" },
      desc = "Toggle LSP Signature Help (robust)",
    },
  },
}
