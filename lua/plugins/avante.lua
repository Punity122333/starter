return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    opts = {
      mode = "agentic",
      provider = "gemini",
      instructions_file = "avante.md",
      -- The top-level gemini key was moved into the providers table below to fix the [DEPRECATED] warning.
      providers = {
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-3-flash-preview",
          timeout = 30000,
          temperature = 0,
          max_tokens = 8192,
        },
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-4o",
          proxy = nil,
          allow_insecure_call = true,
          timeout = 30000,
        },
      },
      behaviour = {
        enable_cursor_planning_mode = true,
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
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
      windows = {
        position = "right",
        width = 23,
        wrap = true,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
      },
      suggestion = {
        throttle = 300,
        debounce = 150,
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
