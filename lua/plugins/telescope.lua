return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    opts = {
      defaults = {
        debounce = 0,
        mappings = {
          n = {
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
      },
    },
  },
}
