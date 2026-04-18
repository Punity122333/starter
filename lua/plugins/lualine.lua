return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
			globalstatus = true,
			refresh = {
				statusline = 100000,
				tabline = 100000,
				winbar = 100000,
			},
		})

		-- Bold mode pill (lualine_a). LazyVim puts "mode" here by default.
		-- gui = "bold" with no fg/bg inherits the theme's section colours,
		-- so it stays correct across every mode and colorscheme.
		opts.sections = opts.sections or {}
		opts.sections.lualine_a = {
			{ "mode", color = { gui = "bold" } },
		}

		-- Bold clock (lualine_z). LazyVim puts the time component here.
		opts.sections.lualine_z = {
			{
				function()
					return os.date("%H:%M")
				end,
				color = { gui = "bold" },
			},
		}

		return opts
	end,
}
