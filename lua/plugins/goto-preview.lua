return {
	"rmagatti/goto-preview",
	event = "BufEnter",
	dependencies = { "rmagatti/logger.nvim" },
	config = function()
		require("goto-preview").setup({
			width = 120,
			height = 15,
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			default_mappings = false,
			debug = false,
			opacity = nil,
			resizing_mappings = false,
			post_open_hook = function(_, win)
				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = true, silent = true, desc = "Close Preview" })
			end,
			post_close_hook = nil,

			references = {
				provider = "telescope",
				telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
			},
			focus_on_open = true,
			dismiss_on_move = false,
			force_close = true,
			bufhidden = "wipe",
			stack_floating_preview_windows = true,
			same_file_float_preview = true,
			preview_window_title = { enable = true, position = "left" },
			zindex = 1,
			vim_ui_input = true,
		})
	end,
	keys = {
		{
			"gd",
			"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
			desc = "Peek Definition",
		},
		{
			"gpi",
			"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
			desc = "Peek Implementation",
		},
		{
			"gpd",
			"<cmd>lua require('goto-preview').close_all_win()<CR>",
			desc = "Close Preview Window",
		},
	},
}
