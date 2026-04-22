return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	config = function()
		require("crates").setup({
			smart_insert = true,
			autoload = true,
			autoupdate = true,
			enable_update_available_warning = true,

			text = {
				searching = "  Searching  ",
				loading = "  Loading  ",
				version = "  %s  ",
				prerelease = "  %s  ",
				yanked = "  %s  ",
				nomatch = "  No match  ",
				upgrade = "  %s  ",
				error = "  Error fetching crate  ",
			},

			highlight = {
				searching = "CratesNvimSearching",
				loading = "CratesNvimLoading",
				version = "CratesNvimVersion",
				prerelease = "CratesNvimPreRelease",
				yanked = "CratesNvimYanked",
				nomatch = "CratesNvimNoMatch",
				upgrade = "CratesNvimUpgrade",
				error = "CratesNvimError",
			},

			popup = {
				autofocus = false,
				hide_on_select = false,
				style = "minimal",
				border = "rounded",
				show_version_date = true,
				show_dependency_version = true,
				max_height = 30,
				min_width = 20,
				padding = 1,
				text = {
					pill_left = "",
					pill_right = "",
				},
			},

			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		})

		local function blend(hex, alpha)
			local r = tonumber(hex:sub(2, 3), 16)
			local g = tonumber(hex:sub(4, 5), 16)
			local b = tonumber(hex:sub(6, 7), 16)
			local bg_r = tonumber("16", 16)
			local bg_g = tonumber("16", 16)
			local bg_b = tonumber("1e", 16)
			return string.format("#%02x%02x%02x",
				math.floor(r * alpha + bg_r * (1 - alpha)),
				math.floor(g * alpha + bg_g * (1 - alpha)),
				math.floor(b * alpha + bg_b * (1 - alpha))
			)
		end

		local function pill(fg)
			return { fg = fg, bg = blend(fg, 0.15), bold = true }
		end

		vim.api.nvim_set_hl(0, "CratesNvimVersion",         pill("#1abc9c")) -- teal
		vim.api.nvim_set_hl(0, "CratesNvimUpgrade",         pill("#e0af68")) -- yellow
		vim.api.nvim_set_hl(0, "CratesNvimPreRelease",      pill("#ff9e64")) -- orange
		vim.api.nvim_set_hl(0, "CratesNvimYanked",          pill("#f7768e")) -- red
		vim.api.nvim_set_hl(0, "CratesNvimNoMatch",         pill("#f7768e")) -- red
		vim.api.nvim_set_hl(0, "CratesNvimError",           pill("#db4b4b")) -- red1
		vim.api.nvim_set_hl(0, "CratesNvimSearching",       pill("#7aa2f7")) -- blue
		vim.api.nvim_set_hl(0, "CratesNvimLoading",         pill("#7aa2f7")) -- blue
		vim.api.nvim_set_hl(0, "CratesNvimPopupTitle",      { link = "FloatTitle" })
		vim.api.nvim_set_hl(0, "CratesNvimPopupPillText",   {})
		vim.api.nvim_set_hl(0, "CratesNvimPopupPillBorder", {})
	end,
}

