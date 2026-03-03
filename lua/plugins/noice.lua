return {
  "folke/noice.nvim",
  opts = {
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
            { find = "shared.lua" }
          },
        },
        opts = { skip = true },
      },
    },
  },
}
