return {
	{ "nvim-mini/mini.pairs", enabled = false },
	{
		"windwp/nvim-autopairs",
		lazy = false,
		opts = {
			check_ts = true,
      enable_check_bracket_line = false,
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

			-- 👇 THIS is the built-in module
			require("nvim-autopairs").add_rules(require("nvim-autopairs.rules.endwise-lua"))
		end,
	},
}
