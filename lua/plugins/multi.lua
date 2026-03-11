return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "main",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup({
        updatetime = 50,
      })
      vim.keymap.set({"n", "v"}, "\\k", function() mc.lineAddCursor(-1) end)
      vim.keymap.set({"n", "v"}, "\\j", function() mc.lineAddCursor(1) end)
      vim.keymap.set({"n", "v"}, "\\n", function() mc.matchAddCursor(1) end)
      vim.keymap.set({"n", "v"}, "\\s", function() mc.matchSkipCursor(1) end)
      vim.keymap.set({"n", "v"}, "\\a", function() mc.matchAllAddCursors() end)
      vim.keymap.set({"n", "v"}, "\\c", function() mc.clearCursors() end)
    end,
  },
  {
    "mg979/vim-visual-multi",
    enabled = false,
  },
}