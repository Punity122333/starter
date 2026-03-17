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
  config = function(_, opts)
    require("noice").setup(opts)

    local function is_in_function_call()
      local node = vim.treesitter.get_node()
      while node do
        local type = node:type()
        if type == "arguments" or type == "parameter_list" or type == "argument_list" then
          return true
        end
        node = node:parent()
      end
      return false
    end

    local function get_sig_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if ft == "lsp_signature" or ft == "noice" then
            return win
          end
        end
      end
      return nil
    end

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = vim.api.nvim_create_augroup("SignatureAutoClose", { clear = true }),
      callback = function()
        if get_sig_win() and not is_in_function_call() then
          require("noice").cmd("dismiss")
        end
      end,
    })
  end,
  keys = {
    {
      "<C-;>",
      function()
        local function get_sig_win()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
              if ft == "lsp_signature" or ft == "noice" then
                return win
              end
            end
          end
          return nil
        end

        if get_sig_win() then
          require("noice").cmd("dismiss")
        else
          vim.lsp.buf.signature_help()
        end
      end,
      mode = { "i", "n" },
      desc = "Toggle LSP Signature Help",
    },
    {
      "<C-,>",
      function()
        local function get_sig_win()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then
              local buf = vim.api.nvim_win_get_buf(win)
              local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
              if ft == "lsp_signature" or ft == "noice" then
                return win
              end
            end
          end
          return nil
        end

        if get_sig_win() then
          require("noice").cmd("dismiss")
        else
          vim.lsp.buf.signature_help()
        end
      end,
      mode = { "i", "n" },
      desc = "Toggle LSP Signature Help",
    },  },
}
