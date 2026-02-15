return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
  picker = {
    icons = {
      selected = "󰄲 ",    -- The "checked" icon (looks way cleaner)
      unselected = "󰄱 ",  -- The "empty" box (keeps the alignment perfect)
      cursor = "❯ ",      -- The indicator for where your actual cursor is
    },
    -- This ensures the icons have enough breathing room
    layout = {
      preset = "default", 
    },
    live_grep = {
          -- force it to use a very minimal set of flags
          -- and ensure it's not being throttled by the OS
          args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
        },
  },
}
}