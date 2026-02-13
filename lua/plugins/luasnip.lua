return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  lazy = true,
  build = "make install_jsregexp",
  opts = {
    history = true,
    delete_check_events = "TextChanged",
    region_check_events = "CursorMoved",
    update_events = { "TextChanged", "TextChangedI" },
  },
  config = function(_, opts)
    local ls = require("luasnip")
    ls.setup(opts)

    -- Load VSCode-style snippets
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
