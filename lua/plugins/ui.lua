return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = false,
      on_highlights = function(hl)
        hl.SignColumn = { bg = "none" }
        hl.LineNr = { bg = "none" }
        hl.StatusLine = { bg = "none" }
        hl.EndOfBuffer = { bg = "none" }
      end,
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      scratch = {
        win = {
          style = "scratch",
          border = "rounded",
          title = "",
          title_pos = "center",
        },
      },
      lazygit = {
        enabled = true,
        theme = {
          optionsTextColor = { fg = "NonText" },
          selectedLineBgColor = { bg = "CursorLine" },
          activeBorderColor = { fg = "Special", bold = true },
        },
        win = {
          style = "lazygit",
          border = "rounded",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    init = function()
      vim.o.timeoutlen = 130
      vim.o.ttimeoutlen = 10
    end,
    opts = {
      delay = 130,
      notify = false,
      spec = {
        { "<leader>gh", group = "Git Hunks" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      exclude = {
        file_types = { "Avante", "AvanteInput" },
      },
    },
  },
  -- SURGICAL FIX: Manually kill Treesitter on Avante buffers to stop the crash
  {
    "yetone/avante.nvim",
    config = function(_, opts)
      require("avante").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "Avante", "AvanteInput" },
        callback = function(ev)
          vim.treesitter.stop(ev.buf)
        end,
      })
    end,
  },
}
