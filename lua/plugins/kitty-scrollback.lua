-- kitty-scrollback.nvim - High-performance Kitty terminal scrollback integration
-- Eliminates lag when viewing terminal history in Neovim
return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    config = function()
      require("kitty-scrollback").setup({
        -- Optimized settings for fast scrollback
        paste_window = {
          -- Paste selected text back to terminal
          yank_register = "+", -- Use system clipboard
          yank_register_enabled = true,
        },
        -- Status window configuration
        status_window = {
          enabled = true,
          style_simple = false,
        },
        -- Keymaps for navigating scrollback
        keymaps_enabled = true,
        -- Visual mode improvements
        visual_selection_highlight_mode = "reverse",
      })
    end,
  },
}
