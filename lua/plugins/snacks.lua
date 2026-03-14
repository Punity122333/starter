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
      enabled = true,
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
    },
    
    input = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      "<leader>gg",
      function() Snacks.terminal("gitui") end,
      desc = "GitUI",
    },
  },
  init = function()
    
    vim.ui.select = function(...)
      return require("snacks").picker.select(...)
    end
    vim.ui.input = function(...)
      return require("snacks").input(...)
    end
  end,
}