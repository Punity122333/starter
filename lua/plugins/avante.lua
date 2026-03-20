return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    opts = {
      notify = false,
      mode = "agentic",
      provider = "gemini",
      instructions_file = "avante.md",
      providers = {
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
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        notify = false,
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
        border = "rounded",
        ask = {
          start_insert = false,
          border = "rounded",
        },
        edit = {
          border = "rounded",
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
