return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      signature = {
        enabled = true,
        auto_open = {
          enabled = false,
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
          },
        },
        opts = { skip = true },
      },
    },
  },
  keys = {
    {
      "<C-k>",
      function()
        vim.g._sig_open = not vim.g._sig_open
        if vim.g._sig_open then
          vim.lsp.buf.signature_help()
        else
          require("noice").cmd("dismiss")
        end
      end,
      mode = { "i", "n" },
      desc = "Toggle LSP Signature Help",
    },
  },
}
