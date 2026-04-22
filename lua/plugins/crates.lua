return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	config = function()
		local cap_l = "\xee\x82\xb6"
		local cap_r = "\xee\x82\xb4"
		local our_ns = vim.api.nvim_create_namespace("crates_pills")
		local crates_ns_id = nil
		local bg_dark = "#16161e"

		local function blend(hex, alpha)
			local r = tonumber(hex:sub(2, 3), 16)
			local g = tonumber(hex:sub(4, 5), 16)
			local b = tonumber(hex:sub(6, 7), 16)
			local br = tonumber(bg_dark:sub(2, 3), 16)
			local bg_g = tonumber(bg_dark:sub(4, 5), 16)
			local bb = tonumber(bg_dark:sub(6, 7), 16)
			return string.format("#%02x%02x%02x",
				math.floor(r * alpha + br * (1 - alpha)),
				math.floor(g * alpha + bg_g * (1 - alpha)),
				math.floor(b * alpha + bb * (1 - alpha))
			)
		end

		local pill_colors = {
			CratesNvimVersion    = "#1abc9c",
			CratesNvimUpgrade    = "#e0af68",
			CratesNvimPreRelease = "#ff9e64",
			CratesNvimYanked     = "#f7768e",
			CratesNvimNoMatch    = "#f7768e",
			CratesNvimError      = "#db4b4b",
			CratesNvimSearching  = "#7aa2f7",
			CratesNvimLoading    = "#7aa2f7",
		}

		local function setup_pill_hls()
			for hl_name, fg in pairs(pill_colors) do
				local blended = blend(fg, 0.15)
				vim.api.nvim_set_hl(0, hl_name .. "CapL", { fg = blended })
				vim.api.nvim_set_hl(0, hl_name .. "CapR", { fg = blended })
				vim.api.nvim_set_hl(0, hl_name .. "Body", { fg = fg, bg = blended, bold = true })
				vim.api.nvim_set_hl(0, hl_name, { fg = bg_dark, bg = "NONE" })
			end
		end

		local function get_crates_ns()
			if crates_ns_id then return crates_ns_id end
			local namespaces = vim.api.nvim_get_namespaces()
			for name, id in pairs(namespaces) do
				if name:find("crates") then
					crates_ns_id = id
					return id
				end
			end
		end

		local function rerender_pills(buf)
			if not vim.api.nvim_buf_is_valid(buf) then return end
			local ns = get_crates_ns()
			if not ns then return end

			local marks = vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, { details = true })
			vim.api.nvim_buf_clear_namespace(buf, our_ns, 0, -1)

			for _, mark in ipairs(marks) do
				local row = mark[2]
				local details = mark[4]
				local virt_text = details.virt_text
				if virt_text and #virt_text > 0 then
					local text, hl = virt_text[1][1], virt_text[1][2]
					if hl and pill_colors[hl] then
						local trimmed = text:gsub("^%s+", ""):gsub("%s+$", "")
						if trimmed ~= "" then
							vim.api.nvim_buf_set_extmark(buf, our_ns, row, 0, {
								virt_text = {
									{ "  ", "Normal" },
									{ cap_l, hl .. "CapL" },
									{ " " .. trimmed .. " ", hl .. "Body" },
									{ cap_r, hl .. "CapR" },
								},
								virt_text_pos = "eol",
								hl_mode = "combine",
								priority = 200,
							})
						end
					end
				end
			end
		end

		require("crates").setup({
			smart_insert = true,
			autoload = true,
			autoupdate = true,
			enable_update_available_warning = true,

			text = {
				searching = " Searching",
				loading = " Loading",
				version = " %s",
				prerelease = " %s",
				yanked = " %s",
				nomatch = " No match",
				upgrade = " %s",
				error = " Error",
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

			on_attach = function(bufnr)
				local uv = vim.uv or vim.loop

				-- initial render after crates fetches data
				vim.defer_fn(function() rerender_pills(bufnr) end, 300)

				-- re-render on edits
				vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
					buffer = bufnr,
					callback = function()
						vim.defer_fn(function() rerender_pills(bufnr) end, 150)
					end,
				})

				-- periodic refresh to catch async network updates from crates
				local timer = uv.new_timer()
				timer:start(800, 800, vim.schedule_wrap(function()
					if vim.api.nvim_buf_is_valid(bufnr) then
						rerender_pills(bufnr)
					else
						timer:stop()
						timer:close()
					end
				end))
			end,
		})

		setup_pill_hls()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_pill_hls })
		vim.api.nvim_set_hl(0, "CratesNvimPopupTitle",      { link = "FloatTitle" })
		vim.api.nvim_set_hl(0, "CratesNvimPopupPillText",   {})
		vim.api.nvim_set_hl(0, "CratesNvimPopupPillBorder", {})
	end,
}
