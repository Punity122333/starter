return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end,
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon Add File",
    },
    {
      "<leader>hh",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon Menu",
    },
    {
      "<C-h>",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon File 1",
    },
    {
      "<C-t>",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon File 2",
    },
    {
      "<C-n>",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon File 3",
    },
    {
      "<C-s>",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon File 4",
    },
  },
  opts = {
    enable = false,
  },
}

