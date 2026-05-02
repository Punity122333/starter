return {
	"chrisgrieser/nvim-rip-substitute",
	keys = {
		{
			"<leader>rs",
			function()
				require("rip-substitute").sub()
			end,
			mode = { "n", "x" },
			desc = " rip-substitute",
		},
		{
			"<leader>rg",
			function()
				require("rip-substitute").sub()
			end,
			mode = { "n", "x" },
			desc = " rip-substitute 2",
		},
	},
	opts = {
		incrementalPreview = {
			debounceMs = 100,
		},
		popupWin = {
      title = "search and replace",
			border = "rounded",
			position = "top",
		},
		ui = {
			position = "top",
			align = "right",
		},
		keymaps = {
			confirmAndSubstituteInBuffer = "<CR>",
			insertModeConfirmAndSubstituteInBuffer = "<C-CR>",
			abort = "q",
			prevSubst = "<C-p>",
			nextSubst = "<C-n>",
		},
	},
}
