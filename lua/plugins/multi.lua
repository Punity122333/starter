return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "main",
		lazy = false,
		config = function()
			local mc = require("multicursor-nvim")

			mc.setup({
				updatetime = 150,
			})

			local function clear_all()
				if mc.hasCursors() then
					mc.clearCursors()
					vim.cmd("redraw!")
					vim.cmd("nohlsearch")
				else
					vim.cmd("nohlsearch")
				end
			end

			local function toggleCursorState()
				if mc.cursorsEnabled() then
					mc.toggleCursor()
					mc.disableCursors()
				else
					mc.toggleCursor()
					mc.enableCursors()
				end
			end

			local set = vim.keymap.set

			set({ "n", "v" }, "L", function()
				if not mc.hasCursors() then
					vim.cmd("normal! n")
				else
					mc.nextCursor()
				end
			end)

			set({ "n", "v" }, "H", function()
				if not mc.hasCursors() then
					vim.cmd("normal! N")
				else
					mc.prevCursor()
				end
			end)

			set({ "n", "v" }, "n", "<Nop>")
			set({ "n", "v" }, "N", "<Nop>")

			set({ "n", "v" }, "\\q", mc.toggleCursor)
			set({ "n", "v" }, "\\k", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "v" }, "\\j", function()
				mc.lineAddCursor(1)
			end)
			set({ "n", "v" }, "\\m", function()
				mc.lineAddCursor(0)
			end)

			set({ "n", "v" }, "\\n", function()
				mc.matchAddCursor(1)
			end)
			set({ "n", "v" }, "\\s", function()
				mc.matchSkipCursor(1)
			end)
			set({ "n", "v" }, "\\a", mc.matchAllAddCursors)

			set({ "n", "v" }, "\\c", clear_all)
			set({ "n", "v" }, "\\w", toggleCursorState) 
		end,
	},
	{
		"mg979/vim-visual-multi",
		enabled = false,
	},
}
