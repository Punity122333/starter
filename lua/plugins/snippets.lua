return {
	"nvim-mini/mini.snippets",
	dependencies = { "rafamadriz/friendly-snippets" },

	opts = function()
		local snips = require("mini.snippets")
		local friendly_dir = require("lazy.core.config").plugins["friendly-snippets"].dir

		return {
			snippets = {

				snips.gen_loader.from_file("~/.config/nvim/snippets/global.json"),
				snips.gen_loader.from_lang({ path = friendly_dir .. "/snippets" }),
				snips.gen_loader.from_lang(),
			},

			-- 💀 KEY FIX: bypass session UI completely
			expand = {
				insert = function(snippet)
					-- use Neovim native snippet expansion (NO UI markers)
					vim.snippet.expand(snippet.body)
				end,
			},
		}
	end,
}
