return {
  "nvim-mini/mini.move",
  version = "*",
  opts = {
    mappings = {
      -- Move visual selection in any direction
      left = "<A-h>",
      right = "<A-l>",
      down = "<A-j>",
      up = "<A-k>",
      -- Line movements
      line_left = "<A-S-h>",
      line_right = "<A-S-l>",
      line_down = "<A-S-j>",
      line_up = "<A-S-k>",
    },
    options = {
      -- Automatically re-indent the line after moving
      reindent_linewise = true,
    },
  },
  config = function(_, opts)
    require("mini.move").setup(opts)
  end,
}
