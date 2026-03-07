return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
   
    explorer = {
      cycle = false,
      win = {
        layout = {
          position = "right", 
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
