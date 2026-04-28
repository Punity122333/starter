return {
	{ "nvim-mini/mini.pairs", enabled = false },
	{
		"windwp/nvim-autopairs",
		lazy = false,
		opts = {
			check_ts = true,
			enable_check_bracket_line = true,
			ts_config = {
				lua = { "string" },
				python = { "string" },
			},
			map_cr = true,
			map_bs = true,
		},
		config = function(_, opts)
			local autopairs = require("nvim-autopairs")
			autopairs.setup(opts)

			-- Load the endwise rules (for then/end, do/end, etc.)
			autopairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))

			-- Create a unified function for Enter and Shift+Enter
			_G.smart_autopairs_cr = function()
				-- calls the internal autopairs <CR> logic
				return autopairs.autopairs_cr()
			end

			-- Map both keys to the same logic
			local map_opts = { expr = true, noremap = true, silent = true }

			-- Use v:lua to call our global function for maximum speed
			vim.keymap.set("i", "<S-CR>", "v:lua.smart_autopairs_cr()", map_opts)
		end,
	},
}
