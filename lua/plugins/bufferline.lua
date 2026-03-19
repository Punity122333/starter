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
  { "<leader>b;", "<cmd>BufferLineGoToBuffer 10<cr>", desc = "Go to buffer ; (10th)" },
  { "<leader>b'", "<cmd>BufferLineGoToBuffer 11<cr>", desc = "Go to buffer ' (11th)" },
}
local GodBg = "#1a1b26"
local LightBlue = "#82aaff"
return {
  {
    "akinsho/bufferline.nvim",
    keys = bufferkeys,
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
          numbers = function(numberopts)
            local lettermap = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
            local letter = lettermap[numberopts.ordinal] or tostring(numberopts.ordinal)
            return string.format("%d (%s)", numberopts.ordinal, letter)
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "file explorer",
              highlight = "directory",
              text_align = "left",
              padding = 0,
            },
            {
              filetype = "rconsole",
              text = "r console",
              highlight = "directory",
              text_align = "left",
              padding = 0,
            },
          },
          filter_callback = function(buf_number, buf_numbers)
            if vim.bo[buf_number].filetype == "rconsole" then
              return false
            end
            return true
          end,
        },
        highlights = {
          fill = { bg = godbg },
          background = { bg = godbg },
          separator = { fg = godbg, bg = godbg },
          separator_visible = { fg = godbg, bg = godbg },
          separator_selected = { fg = godbg, bg = godbg },
          indicator_selected = {
            fg = lightblue,
            bg = godbg,
          },
          buffer_visible = { bg = godbg },
          buffer_selected = {
            bg = godbg,
            fg = lightblue,
            bold = true,
            italic = false,
          },
          offset_separator = { fg = godbg, bg = godbg },
          numbers = { fg = "#7aa2f7", bg = godbg, bold = true },
          numbers_selected = { fg = "#fa7355", bg = godbg, bold = true },
          close_button = { bg = godbg },
          close_button_visible = { bg = godbg },
          close_button_selected = { bg = godbg },
          modified = { bg = godbg },
          modified_visible = { bg = godbg },
          modified_selected = { bg = godbg },
          hint_visible = { bg = godbg },
          info_visible = { bg = godbg },
          warning_visible = { bg = godbg },
          error_visible = { bg = godbg },
          diagnostic_visible = { bg = godbg },
        },
      }
    end,
  },
}

