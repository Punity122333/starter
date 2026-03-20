return {
  "nvim-mini/mini.ai",
  lazy = false,
  opts = function(_, opts)
    opts.n_lines = 500
    opts.search_method = "cover_or_nearest"
    opts.silent = false
    return opts
  end,
}
