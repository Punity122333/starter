return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      ui = {
        border = "rounded",
        devicon = true,
      },
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
