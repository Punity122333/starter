local BROWSE_KEYS = {
  { "<leader>sb", "<cmd>Browse<cr>", desc = "Browse (Telescope UI)" },
  { "<leader>sm", "<cmd>BrowseMdn<cr>", desc = "Search MDN" },
}
local BROWSE_PROVIDER = "google"
return {
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = BROWSE_KEYS,
    opts = {
      provider = BROWSE_PROVIDER,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      vim.keymap.set("n", "<leader>sD", function()
        local word = vim.fn.expand("<cword>")
        local ft = vim.bo.filetype
        vim.ui.open("https://devdocs.io/#q=" .. ft .. "%20" .. word)
      end, { desc = "Fast DevDocs (No UI)" })

      vim.keymap.set("n", "<leader>sG", function()
        local word = vim.fn.expand("<cword>")
        vim.ui.open("https://www.google.com/search?q=" .. word)
      end, { desc = "Fast Google (No UI)" })
    end,
  },
}
