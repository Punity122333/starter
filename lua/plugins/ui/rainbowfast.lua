return {
	"Punity122333/rainbow-fast.nvim",
	branch = "main",
	lazy = false,
	config = function()
		local rf = require("rainbow-fast")
		rf.setup({
			brackets_enabled = true, -- set false to start with brackets off
			keywords_enabled = false, -- set false to start with keywords off
		})

		-- sh and zsh use the bash TS parser, so reuse its keyword config
		local bash = rf.config.keyword_langs.bash
		rf.config.keyword_langs.sh = bash
		rf.config.keyword_langs.zsh = bash

		-- keybinds
		vim.keymap.set("n", "<leader>rr", rf.toggle, { desc = "Rainbow: toggle all" })
		vim.keymap.set("n", "<leader>rj", rf.toggle_brackets, { desc = "Rainbow: toggle brackets" })
		vim.keymap.set("n", "<leader>rk", rf.toggle_keywords, { desc = "Rainbow: toggle keywords" })
	end,
}
