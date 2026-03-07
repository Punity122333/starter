
return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    config = function()
      require("kitty-scrollback").setup({

        paste_window = {

          yank_register = "+", 
          yank_register_enabled = true,
        },
       
        status_window = {
          enabled = true,
          style_simple = false,
        },
  
        keymaps_enabled = true,

        visual_selection_highlight_mode = "reverse",
      })
    end,
  },
}
