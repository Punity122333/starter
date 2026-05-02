
return {
  "gbprod/substitute.nvim",
  event = { "BufReadPost", "BufNewFile" },

  opts = {
    highlight_substituted_text = {
      enabled = true,
      timer = 100,
    },
    yank_substituted_text = false,
    preserve_cursor_position = false,
  },

  keys = {
    {
      "gl",
      function()
        require("substitute").operator()
      end,
      desc = "Substitute with motion",
    },
    {
      "gll",
      function()
        require("substitute").line()
      end,
      desc = "Substitute line",
    },
    {
      "gL",
      function()
        require("substitute").eol()
      end,
      desc = "Substitute to EOL",
    },
    {
      "gl",
      function()
        require("substitute").visual()
      end,
      mode = "x",
      desc = "Substitute visual",
    },
  },
}

