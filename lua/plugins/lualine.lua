-- Track mini.snippets session state via events instead of polling session.get().
-- This is reliable regardless of mode or timing.
local _snippet_active = false

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniSnippetsSessionStart",
	callback = function()
		_snippet_active = true
		require("lualine").refresh({ place = { "statusline" } })
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniSnippetsSessionStop",
	callback = function()
		_snippet_active = false
		require("lualine").refresh({ place = { "statusline" } })
	end,
})

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
					if _snippet_active then
						return "SNIPPET"
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
						s = "SELECT",
						S = "S-LINE",
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

