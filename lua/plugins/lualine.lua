return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
			globalstatus = true,
			refresh = {
				statusline = 100000,
				tabline    = 100000,
				winbar     = 100000,
			},
		})
		opts.sections = opts.sections or {}

		-- Mode component: bold always, shows SNIPPET when snippet session is active.
		-- Uses fmt (not color function) to avoid infinite highlight group creation.
		-- engine.lua calls redrawstatus on session start/stop so this stays in sync.
		opts.sections.lualine_a = {
			{
				"mode",
				color = { gui = "bold" },
				fmt = function(str)
					local ok, engine = pcall(require, "snippet_engine")
					if ok and engine.get_session() then
						return "SNIPPET"
					end
					return str
				end,
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


