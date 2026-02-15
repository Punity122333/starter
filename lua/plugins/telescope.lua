return {
  {
    "nvim-telescope/telescope.nvim",
    -- this is the magic bit. lazy = false makes it load on startup
    -- so it's already in memory when you hit your first search
    lazy = false, 
    opts = {
      defaults = {
        -- set debounce to 0 for instant response if you're a fast typer
        debounce = 0,
      },
    },
  },
}