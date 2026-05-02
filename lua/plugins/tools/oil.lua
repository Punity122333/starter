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
					vim.cmd("botright vsplit")
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
	config = function(_, opts)
		require("oil").setup(opts)

		local augroup = vim.api.nvim_create_augroup("OilLualineFix", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = "oil",
			callback = function(ev)
				local win = vim.fn.bufwinid(ev.buf)
				if win == -1 then
					return
				end
				vim.api.nvim_set_option_value("statusline", " ", { win = win })
				vim.api.nvim_set_option_value("winbar", "", { win = win })

				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(win),
					once = true,
					callback = function()
						vim.schedule(function()
							pcall(function()
								require("lualine").refresh({ place = { "statusline", "winbar" } })
							end)
						end)
					end,
				})
			end,
		})
	end,
}
