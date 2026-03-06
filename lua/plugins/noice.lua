return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      signature = {
        enabled = true,
        auto_open = {
          enabled = true, -- no more auto-popups while typing
        },
      },
    },
    routes = {
      {
        filter = {
          any = {
            -- The yield/treesitter noise
            { find = "attempt to yield across C-call boundary" },
            { find = "languagetree.lua" },
            { find = "tree_sitter_markdown_parse_code_blocks" },
            -- The new semantic tokens crash
            { find = "semanticTokensProvider" },
            { find = "semantic_tokens.lua" },
            { find = "shared.lua" },
            { find = "Invalid window" },
            { find = "selected model" },
            { find = "Using" }
          },
        },
        opts = { skip = true },
      },
    },
  },
}