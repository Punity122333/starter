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
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile", -- Optimization: only loads when you actually open a file
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      -- The "VS Code Replacement" feature: Inline Blame
      current_line_blame = true, -- Shows who broke the code in real-time
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- End of line, just like GitLens
        delay = 500,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation: Jump between hunks like a pro
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions: Stage and Reset (The 100+ extension replacement)
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk")
        map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk")
        
        -- Preview and Diff
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        
        -- Toggle deleted lines (good for debugging EBA logic)
        map("n", "<leader>ghb", gs.toggle_current_line_blame, "Toggle Blame")
        map("n", "<leader>ghx", gs.toggle_deleted, "Toggle Deleted")
      end,
    },
  },
}
