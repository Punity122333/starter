local BROWSE_KEYS = {
  { "<leader>sb", "<cmd>Browse<cr>", desc = "Browse (Telescope UI)" },
}
local BROWSE_PROVIDER = "google"
return {
  {
    "lalitmee/browse.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = BROWSE_KEYS,
    opts = {
      provider = BROWSE_PROVIDER,
    },
  },

}
