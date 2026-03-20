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
    -- remove lspsaga's operator-pending mappings so mini.ai keeps control
    pcall(vim.keymap.del, "o", "i")
    pcall(vim.keymap.del, "o", "a")
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  animate = false,
}
