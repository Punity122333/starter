return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	config = function()
		vim.diagnostic.config({ virtual_text = false })

		require("tiny-inline-diagnostic").setup({
			preset = "modern",
			options = {
				multilines = {
					enabled = true,
					always_show = true,
				},
				show_source = true,
				enable_on_insert = true,
				throttle = 200,
				overflow = { mode = "truncate" },
				max_width = 60,
			},
		})

		local ns = vim.api.nvim_create_namespace("cursor_line_diag_patch")
		local cap_l = "\xee\x82\xb6" -- U+E0B6
		local cap_r = "\xee\x82\xb4" -- U+E0B4

		local sev_names = {
			[vim.diagnostic.severity.ERROR] = "Error",
			[vim.diagnostic.severity.WARN] = "Warn",
			[vim.diagnostic.severity.INFO] = "Info",
			[vim.diagnostic.severity.HINT] = "Hint",
		}

		local hl_map = {
			[vim.diagnostic.severity.ERROR] = "TinyInlineDiagnosticVirtualTextError",
			[vim.diagnostic.severity.WARN] = "TinyInlineDiagnosticVirtualTextWarn",
			[vim.diagnostic.severity.INFO] = "TinyInlineDiagnosticVirtualTextInfo",
			[vim.diagnostic.severity.HINT] = "TinyInlineDiagnosticVirtualTextHint",
		}
		local function int_to_hex(int)
			if not int then
				return nil
			end
			return string.format("#%06x", int)
		end

		local function setup_patch_hls()
			local cursorline_bg = int_to_hex(vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg)

			for sev, hl_name in pairs(hl_map) do
				local name = sev_names[sev]
				local body_hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
				local body_bg = int_to_hex(body_hl.bg)
				local body_fg = int_to_hex(body_hl.fg)

				vim.api.nvim_set_hl(0, "CursorDiagArrow" .. name, {
					fg = NONE,
					bg = cursorline_bg,
				})
				vim.api.nvim_set_hl(0, "CursorDiagCapL" .. name, {
					fg = body_bg,
					bg = cursorline_bg,
				})
				vim.api.nvim_set_hl(0, "CursorDiagCapR" .. name, {
					fg = body_bg,
					bg = cursorline_bg,
				})
			end
		end

		vim.schedule(setup_patch_hls)

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup_patch_hls)
			end,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "DiagnosticChanged" }, {
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				local line = vim.api.nvim_win_get_cursor(0)[1] - 1

				vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

				local diags = vim.diagnostic.get(buf, { lnum = line })
				if #diags == 0 then
					return
				end

				table.sort(diags, function(a, b)
					return a.severity < b.severity
				end)
				local diag = diags[1]

				local msg = diag.message:gsub("\n", " ")
				if #msg > 60 then
					msg = msg:sub(1, 60) .. "…"
				end

				local name = sev_names[diag.severity]
				local hl = hl_map[diag.severity]

				vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {

					virt_text = {
						{ " ←   ", "CursorDiagArrow" .. name },
						{ cap_l, "CursorDiagCapL" .. name },
						{ " ● " .. msg .. " ", hl },
						{ cap_r, "CursorDiagCapR" .. name },
					},

					virt_text_pos = "eol",
					hl_mode = "replace",
					priority = 999,
				})
			end,
		})
	end,
}
