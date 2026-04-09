
return {
  "monaqa/dial.nvim",
  lazy = false,
  keys = {
    { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
    { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
  },
  config = function()
  end,
}
