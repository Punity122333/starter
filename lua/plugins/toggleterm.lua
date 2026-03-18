return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      shade_terminals = true,
      direction = "float", 
      float_opts = {
        border = "rounded",
        winblend = 3,
      },
    })
  end
}
