return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	opts = {

		actions = {
			jump = function(view)
				local item = view:current()
				if item and item.buf and item.lnum then
					local line_count = vim.api.nvim_buf_line_count(item.buf)

					if item.lnum > line_count then
						local padding = {}
						for _ = 1, (item.lnum - line_count) do
							table.insert(padding, "")
						end
						vim.api.nvim_buf_set_lines(item.buf, line_count, line_count, false, padding)
					end
				end

				require("trouble.view.actions").jump(view)
			end,
		},
	},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
	},
}

