return {
  {
    "https://github.com/aspeddro/gitui.nvim",
    cmd = { "GitUI" },
    keys = {
      { "<leader>gg", "<cmd>GitUI<cr>", desc = "GitUI" },
    },
    config = function()
      require("gitui").setup({
        window = {
          options = {
            border = "rounded",
            width = 0.9,
            height = 0.9,
          },
        },
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gk", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gK", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
      { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
    },
  },
}
