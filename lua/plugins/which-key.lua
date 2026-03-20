return {
  "folke/which-key.nvim",
  opts = {
    delay = 300,
    triggers = {
      { "<auto>", mode = "nxs" }, -- removed "o" to skip operator-pending mode
    },
  },
}
