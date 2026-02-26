return {
  -- 1. The Browse Plugin (For the UI/Telescope integration)
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      -- Use <leader>sb for the big Telescope "Browse" menu
      { "<leader>sb", "<cmd>Browse<cr>", desc = "Browse (Telescope UI)" },
      -- Use <leader>sm for MDN (Web dev)
      { "<leader>sm", "<cmd>BrowseMdn<cr>", desc = "Search MDN" },
    },
    opts = {
      provider = "google",
    },
  },

  -- 2. Custom Keymaps (The DIY "Fast" way)
  -- We put these in a plugin spec 'init' or 'config' to keep it clean,
  -- or you can just put these in your keymaps.lua
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- FAST SEARCH: Just jumps to DevDocs based on cursor word
      vim.keymap.set("n", "<leader>sD", function()
        local word = vim.fn.expand("<cword>")
        local ft = vim.bo.filetype
        vim.ui.open("https://devdocs.io/#q=" .. ft .. "%20" .. word)
      end, { desc = "Fast DevDocs (No UI)" })

      -- FAST SEARCH: Just google the error/word
      vim.keymap.set("n", "<leader>sG", function()
        local word = vim.fn.expand("<cword>")
        vim.ui.open("https://www.google.com/search?q=" .. word)
      end, { desc = "Fast Google (No UI)" })
    end,
  },
}
