local GITUI_CMD = { "GitUI" }
local GITUI_KEY = { "<leader>gg", "<cmd>GitUI<cr>", desc = "GitUI" }
local GITUI_BORDER = "rounded"
local GITUI_WIDTH = 0.9
local GITUI_HEIGHT = 0.9
local LAZYGIT_CMDS = {
  "LazyGit",
  "LazyGitConfig",
  "LazyGitCurrentFile",
  "LazyGitFilter",
  "LazyGitFilterCurrentFile",
}
local LAZYGIT_KEYS = {
  { "<leader>gk", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  { "<leader>gK", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
  { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
}
local GitsignsSigns = {
  add = { text = "▎" },
  change = { text = "▎" },
  delete = { text = "" },
  topdelete = { text = "" },
  changedelete = { text = "▎" },
  untracked = { text = "▎" },
}
local GitsignsBlameOpts = {
  virt_text = true,
  virt_text_pos = "eol",
  delay = 500,
}
return {
  {
    "https://github.com/aspeddro/gitui.nvim",
    cmd = GITUI_CMD,
    keys = { GITUI_KEY },
    config = function()
      require("gitui").setup({
        window = {
          options = {
            border = GITUI_BORDER,
            width = GITUI_WIDTH,
            height = GITUI_HEIGHT,
          },
        },
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = LAZYGIT_CMDS,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = LAZYGIT_KEYS,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = GitsignsSigns,
      current_line_blame = true,
      current_line_blame_opts = GitsignsBlameOpts,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk")
        map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghb", gs.toggle_current_line_blame, "Toggle Blame")
        map("n", "<leader>ghx", gs.toggle_deleted, "Toggle Deleted")
      end,
    },
  },
}
