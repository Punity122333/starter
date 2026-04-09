return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{
			"-",
			function()
				local oil_win = nil
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local bufnr = vim.api.nvim_win_get_buf(win)
					if vim.bo[bufnr].filetype == "oil" then
						oil_win = win
						break
					end
				end

				if oil_win then
					vim.api.nvim_win_close(oil_win, true)
				else
					vim.cmd("vsplit")
					vim.cmd("wincmd L")
					require("oil").open()
					vim.api.nvim_win_set_width(0, 41)
				end
			end,
			desc = "Toggle Oil sidebar",
		},
	},
	opts = {
		default_file_explorer = false,
		skip_confirm_for_simple_edits = true,
		win_options = {
			number = false,
			relativenumber = false,
			signcolumn = "no",
			foldcolumn = "1",
			winbar = "",
			statusline = "",
		},
		keymaps = {
			["<C-h>"] = {
				callback = function()
					vim.cmd("wincmd h")
				end,
				desc = "Move left",
			},
			["<C-l>"] = {
				callback = function()
					vim.cmd("wincmd l")
				end,
				desc = "Move right",
			},
			["-"] = {
				callback = function()
					vim.cmd("q")
				end,
				desc = "Close oil",
			},

			-- multicursor.nvim keymaps integrated into oil
			["\\q"] = {
				callback = function()
					require("multicursor-nvim").toggleCursor()
				end,
				desc = "MC Toggle",
			},
			["\\k"] = {
				callback = function()
					require("multicursor-nvim").lineAddCursor(-1)
				end,
				desc = "MC Add Up",
			},
			["\\j"] = {
				callback = function()
					require("multicursor-nvim").lineAddCursor(1)
				end,
				desc = "MC Add Down",
			},
			["\\m"] = {
				callback = function()
					require("multicursor-nvim").lineAddCursor(0)
				end,
				desc = "MC Add Here",
			},
			["\\n"] = {
				callback = function()
					require("multicursor-nvim").matchAddCursor(1)
				end,
				desc = "MC Match Next",
			},
			["\\s"] = {
				callback = function()
					require("multicursor-nvim").matchSkipCursor(1)
				end,
				desc = "MC Skip Next",
			},
			["\\a"] = {
				callback = function()
					require("multicursor-nvim").matchAllAddCursors()
				end,
				desc = "MC Match All",
			},
			["\\c"] = {
				callback = function()
					require("multicursor-nvim").clearCursors()
				end,
				desc = "MC Clear",
			},
		},
		columns = { "icon" },
		view_options = {
			show_hidden = true,
		},
	},
}
