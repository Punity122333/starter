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
		popupWin = {
			border = "rounded",
			position = "top",
		},
		ui = {
			position = "top",
			align = "right",
		},
		keymaps = {
			confirmAndSubstiituteInBuffer = "<CR>",
			insertModeConfirmAndSubstituteInBuffer = "<C-CR>",
			abort = "q",
			prevSubst = "<C-p>",
			nextSubst = "<C-n>",
		},
	},
}
