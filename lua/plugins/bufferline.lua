return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>ba", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer A (1st)" },
      { "<leader>bs", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer S (2nd)" },
      { "<leader>bd", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer D (3rd)" },
      { "<leader>bf", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer F (4th)" },
      { "<leader>bg", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer G (5th)" },
      { "<leader>bh", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer H (6th)" },
      { "<leader>bj", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer J (7th)" },
      { "<leader>bk", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer K (8th)" },
      { "<leader>bl", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer L (9th)" },
    },
    opts = function()
      -- THE GOD HEX
      local god_bg = "#1a1b26"
      local light_blue = "#82aaff"
      
      return {
        options = {
          always_show_bufferline = false,
          indicator = {
            icon = '▎', 
            style = 'icon',
          },
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          numbers = function(number_opts)
            local letter_map = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
            local letter = letter_map[number_opts.ordinal] or tostring(number_opts.ordinal)
            return string.format("%d (%s)", number_opts.ordinal, letter)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              -- THIS IS THE FIX: Ensuring the offset background matches the void
              padding = 0,
            },
          },
        },
        highlights = {
          -- THE NUCLEAR OVERRIDE: Hardcoding the hex instead of using theme variables
          fill = { bg = god_bg },
          background = { bg = god_bg },
          
          -- Kill the separators by making them the same color as the background
          separator = { fg = god_bg, bg = god_bg },
          separator_visible = { fg = god_bg, bg = god_bg },
          separator_selected = { fg = god_bg, bg = god_bg },

          -- Restore the blue indicator
          indicator_selected = { 
            fg = light_blue, 
            bg = god_bg 
          },

          -- Text and Tabs
          buffer_visible = { bg = god_bg },
          buffer_selected = { 
            bg = god_bg, 
            fg = light_blue, 
            bold = true, 
            italic = false 
          },
          
          -- Offset area fix (the part above Neo-tree)
          offset_separator = { fg = god_bg, bg = god_bg },

          -- Diagnostics and extra UI bits
          numbers = { fg = "#7aa2f7", bg = god_bg, bold = true },
          numbers_selected = { fg = "#FA7355", bg = god_bg, bold = true },
          close_button = { bg = god_bg },
          close_button_visible = { bg = god_bg },
          close_button_selected = { bg = god_bg },
          modified = { bg = god_bg },
          modified_visible = { bg = god_bg },
          modified_selected = { bg = god_bg },

          -- Catching the "Visible" tab states
          hint_visible = { bg = god_bg },
          info_visible = { bg = god_bg },
          warning_visible = { bg = god_bg },
          error_visible = { bg = god_bg },
          diagnostic_visible = { bg = god_bg },
        },
      }
    end,
  },
}