local BufferKeys = {
  { "<leader>ba", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer A (1st)" },
  { "<leader>bs", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer S (2nd)" },
  { "<leader>bd", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer D (3rd)" },
  { "<leader>bf", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer F (4th)" },
  { "<leader>bg", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer G (5th)" },
  { "<leader>bh", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer H (6th)" },
  { "<leader>bj", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer J (7th)" },
  { "<leader>bk", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer K (8th)" },
  { "<leader>bl", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer L (9th)" },
}
local GodBg = "#1a1b26"
local LightBlue = "#82aaff"
return {
  {
    "akinsho/bufferline.nvim",
    keys = BufferKeys,
    opts = function()
      return {
        options = {
          always_show_bufferline = false,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          numbers = function(numberOpts)
            local letterMap = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
            local letter = letterMap[numberOpts.ordinal] or tostring(numberOpts.ordinal)
            return string.format("%d (%s)", numberOpts.ordinal, letter)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              padding = 0,
            },
          },
        },
        highlights = {
          fill = { bg = GodBg },
          background = { bg = GodBg },
          separator = { fg = GodBg, bg = GodBg },
          separator_visible = { fg = GodBg, bg = GodBg },
          separator_selected = { fg = GodBg, bg = GodBg },
          indicator_selected = {
            fg = LightBlue,
            bg = GodBg,
          },
          buffer_visible = { bg = GodBg },
          buffer_selected = {
            bg = GodBg,
            fg = LightBlue,
            bold = true,
            italic = false,
          },
          offset_separator = { fg = GodBg, bg = GodBg },
          numbers = { fg = "#7aa2f7", bg = GodBg, bold = true },
          numbers_selected = { fg = "#FA7355", bg = GodBg, bold = true },
          close_button = { bg = GodBg },
          close_button_visible = { bg = GodBg },
          close_button_selected = { bg = GodBg },
          modified = { bg = GodBg },
          modified_visible = { bg = GodBg },
          modified_selected = { bg = GodBg },
          hint_visible = { bg = GodBg },
          info_visible = { bg = GodBg },
          warning_visible = { bg = GodBg },
          error_visible = { bg = GodBg },
          diagnostic_visible = { bg = GodBg },
        },
      }
    end,
  },
}

