local BackgroundColor = "#1a1b26"
local AccentColor = "#82aaff"
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
          numbers = function(numberOptions)
            local keyMapping = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
            local keyLabel = keyMapping[numberOptions.ordinal] or tostring(numberOptions.ordinal)
            return string.format("%d (%s)", numberOptions.ordinal, keyLabel)
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
          filter_callback = function(bufferNumber, bufferNumbers)
            if vim.bo[bufferNumber].filetype == "rconsole" then
              return false
            end
            return true
          end,
        },
        highlights = {
          fill = { bg = BackgroundColor },
          background = { bg = BackgroundColor },
          separator = { fg = BackgroundColor, bg = BackgroundColor },
          separator_visible = { fg = BackgroundColor, bg = BackgroundColor },
          separator_selected = { fg = BackgroundColor, bg = BackgroundColor },
          indicator_selected = {
            fg = AccentColor,
            bg = BackgroundColor,
          },
          buffer_visible = { bg = BackgroundColor },
          buffer_selected = {
            bg = BackgroundColor,
            fg = AccentColor,
            bold = true,
            italic = false,
          },
          offset_separator = { fg = BackgroundColor, bg = BackgroundColor },
          numbers = { fg = "#7aa2f7", bg = BackgroundColor, bold = true },
          numbers_selected = { fg = "#fa7355", bg = BackgroundColor, bold = true },
          close_button = { bg = BackgroundColor },
          close_button_visible = { bg = BackgroundColor },
          close_button_selected = { bg = BackgroundColor },
          modified = { bg = BackgroundColor },
          modified_visible = { bg = BackgroundColor },
          modified_selected = { bg = BackgroundColor },
          hint_visible = { bg = BackgroundColor },
          info_visible = { bg = BackgroundColor },
          warning_visible = { bg = BackgroundColor },
          error_visible = { bg = BackgroundColor },
          diagnostic_visible = { bg = BackgroundColor },
        },
      }
    end,
  },
}

