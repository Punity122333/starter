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

		opts.sections = opts.sections or {}

		opts.sections.lualine_a = {
			{
				function()
					if _G.MiniSnippets and _G.MiniSnippets.session.get() then
						return "SNIP"
					end

					local m = vim.api.nvim_get_mode().mode
					return ({
						n = "NORMAL",
						i = "INSERT",
						v = "VISUAL",
						V = "V-LINE",
						["\22"] = "V-BLOCK",
						c = "COMMAND",
						t = "TERMINAL",
					})[m] or m
				end,
				color = { gui = "bold" },
			},
		}
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
