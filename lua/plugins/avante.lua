return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = true,
    build = "make",
    opts = {
      provider = "copilot",
      -- NEW: Move specific provider configs into this table
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-4o", -- Or "claude-3.5-sonnet"
          proxy = nil,
          allow_insecure_call = true,
          timeout = 30000,
        },
      },
      behaviour = {
        auto_suggestions = false, -- Still OFF as requested
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
      -- Keeping your Snacks integration for that clean UI
      input = {
        provider = "snacks",
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        focus = "<leader>af",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
          suggestion = "<leader>as",
          repology = "<leader>ar",
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
