return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- We keep the theme SOLID so your code is readable
      colorscheme = "tokyonight", 
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = false, -- Middle stays solid
      on_highlights = function(hl, c)
        -- We kill the background ONLY on the parts that touch the borders
        hl.SignColumn = { bg = "none" }    -- Left edge
        hl.LineNr = { bg = "none" }        -- Line number strip
        hl.StatusLine = { bg = "none" }    -- Bottom edge
        hl.EndOfBuffer = { bg = "none" }   -- Bottom empty space
      end,
    },
  },
   {
  "folke/snacks.nvim",
  opts = {
    scratch = {
      win = {
        style = "scratch",
        border = "rounded", -- Rounded corners look way more "pro"
        title = "", -- Adding spaces = Instant de-jank
        title_pos = "center",
      },
    },
  },
}
}
