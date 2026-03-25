return {
  {
    "nvim-mini/mini.splitjoin",
    opts = {
      mappings = {
        toggle = "gS",
        split = "",
        join = "gJ",
      },
    },
    keys = {
      { "gS", desc = "Split/Join Toggle" },
      { "gJ", desc = "Join Arguments" },
    },
  },
}
