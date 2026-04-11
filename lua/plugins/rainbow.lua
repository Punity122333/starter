return {
	"hiphish/rainbow-delimiters.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
				lua = 210,
			},
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		})

		-- Rainbow-delimiters uses its own lib.callback path, separate from
		-- TSHighlighter. Patch it to skip redraws while any key is held.
		vim.defer_fn(function()
			local ok, lib = pcall(require, "rainbow-delimiters.lib")
			if not ok then
				return
			end

			-- The update function name differs by version; try both.
			local fn_name = lib.update_range and "update_range" or lib.update and "update" or nil
			if not fn_name then
				return
			end

			local orig = lib[fn_name]
			local _uv = vim.uv or vim.loop
			local _holding = false
			local _hold_timer = _uv.new_timer()
			local _dirty = {}

			vim.on_key(function()
				_holding = true
				_hold_timer:stop()
				_hold_timer:start(
					100,
					0,
					vim.schedule_wrap(function()
						_holding = false
						for key, args in pairs(_dirty) do
							_dirty[key] = nil
							pcall(orig, table.unpack(args))
						end
					end)
				)
			end)

			lib[fn_name] = function(...)
				if _holding then
					_dirty[tostring({ ... })] = { ... }
					return
				end
				orig(...)
			end
		end, 200)
	end,
}
