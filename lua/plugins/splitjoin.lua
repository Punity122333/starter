return {
  {
    "nvim-mini/mini.splitjoin",
    opts = {
      mappings = {
        toggle = "gS",
        split = "gS",
        join = "gJ",
      },
    },
    keys = {
      { "gS", desc = "Split/Join Toggle" },
      { "gJ", desc = "Join Arguments" },
    },
  },
}
