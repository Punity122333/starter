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
	},
	opts = {
		popupWin = {
			border = "rounded",
			position = "top",
		},
		ui = {
			-- This moves it to the right side
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
