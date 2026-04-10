
return {
  {
    "hedyhli/outline.nvim",
    opts = {
      providers = {
        priority = { "lsp", "markdown" }, -- removed treesitter
      },
      symbol_folding = {
        autofold_depth = 1,
      },
      outline_window = {
        position = "right",
        width = 25,
      },
    },
  },
}

