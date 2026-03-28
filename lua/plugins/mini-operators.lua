return {
  {
    "nvim-mini/mini.nvim",
    opts = {
      operators = {
        evaluate = { prefix = "gm=" },
        exchange = { prefix = "gmx" },
        multiply = { prefix = "gmm" },
        replace  = { prefix = "gmr" },
        sort     = { prefix = "gms" },
      },
    },
    config = function(_, opts)
      require("mini.operators").setup(opts.operators)
    end,
  },
}
