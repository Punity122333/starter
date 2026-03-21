return {
  "j-hui/fidget.nvim",
  lazy = false,
  opts = {
    progress = {
      poll_rate = 0,
      ignore_done_already = true,
      ignore_empty_message = true,
      display = {
        render_limit = 1,
        done_ttl = 1,
        done_icon = "✓",
        progress_icon = { pattern = "dots" },
      },
    },
    notification = {
      poll_rate = 10,
      filter = vim.log.levels.INFO,
      override_vim_notify = false,
      window = {
        winblend = 0,
        zindex = 45,
        max_width = 50,
        max_height = 1,
        x_padding = 0,
        y_padding = 0,
        align = "top",
        relative = "editor",
      },
    },
  },
}
