return {
	"nvim-mini/mini.hipatterns",
	opts = function(_, opts)
		local hi = require("mini.hipatterns")

		-- Wrap the internal function that mints dynamic hex-colour groups.
		-- Every new group gets bold=true injected right after creation.
		local orig = hi.compute_hex_color_group
		hi.compute_hex_color_group = function(hex, style)
			local group = orig(hex, style)
			local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
			hl.bold = true
			vim.api.nvim_set_hl(0, group, hl)
			return group
		end

		-- Static keyword groups (FIXME / HACK / TODO / NOTE) are just named hl
		-- groups — patch them once now and again on every theme change.
		local keyword_groups = {
			"MiniHipatternsFix",
			"MiniHipatternsHack",
			"MiniHipatternsTodo",
			"MiniHipatternsNote",
		}

		local function bold_keywords()
			for _, name in ipairs(keyword_groups) do
				local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
				if next(hl) then
					hl.bold = true
					vim.api.nvim_set_hl(0, name, hl)
				end
			end
		end

		bold_keywords()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = bold_keywords })

		return opts
	end,
}
