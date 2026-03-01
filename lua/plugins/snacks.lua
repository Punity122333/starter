return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
    -- This sets your explorer width to 15%
    explorer = {
      win = {
        layout = {
          position = "right", -- or "left", whichever you prefer
          width = 0.15,
        },
      },
    },
    picker = {
      icons = {
        selected = "󰄲 ",
        unselected = "󰄱 ",
        cursor = "❯ ",
      },
      layout = {
        preset = "default",
      },
      live_grep = {
        args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      },
      keys = {
        {
          "<leader>gg",
          function()
            Snacks.terminal("gitui")
          end,
          desc = "GitUI",
        },
      },
    },
  },
}
