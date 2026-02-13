return {
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      user_id = nil,
      display = {
        show_time = true,
        show_repository = true,
        show_cursor_position = true,
      },
      lsp = {
        show_problem_count = true,
        severity = 1,
      },
      idle = {
        enabled = true,
        timeout = 300000,
        text = "Idle",
      },
    },
  },
}
