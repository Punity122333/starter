return {
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      user_id = nil,
      idle = {
        enabled = true,
        timeout = 300000,
      },
    },
  },
}
