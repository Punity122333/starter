
return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets", 
  },
  opts = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
  },
  config = function(_, opts)
    local ls = require("luasnip")
    ls.config.set_config(opts)

    require("luasnip.loaders.from_vscode").lazy_load()

    ls.add_snippets("cpp", {
      ls.snippet("cppbase", {
        ls.text_node({ "#include <iostream>", "using namespace std;", "", "int main() {", "\t" }),
        ls.insert_node(1, "// logic"),
        ls.text_node({ "", "\treturn 0;", "}" }),
      }),
      ls.snippet("fio", {
        ls.text_node({ "ios_base::sync_with_stdio(false);", "cin.tie(NULL);" }),
      }),
    })
  end,
}

