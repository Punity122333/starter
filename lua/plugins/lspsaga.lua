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
        enable = false, -- Keeps the UI clean for low-level dev
      },
      lightbulb = {
        enable = false, -- Less visual noise while coding
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Highlighting
    "nvim-tree/nvim-web-devicons", -- Icons
  },
}
