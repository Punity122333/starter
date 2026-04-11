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
				show_source = false,
				enable_on_insert = false,
				throttle = 500,
				overflow = { mode = "truncate" },
				max_width = 60,
			},
		})

		local ns = vim.api.nvim_create_namespace("cursor_line_diag_patch")
		local diag_id = 1337
		local cap_l = "\xee\x82\xb6"
		local cap_r = "\xee\x82\xb4"

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
			local comment_fg = int_to_hex(vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg)
			for sev, hl_name in pairs(hl_map) do
				local name = sev_names[sev]
				local body_hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
				local body_bg = int_to_hex(body_hl.bg)

				vim.api.nvim_set_hl(0, "CursorDiagArrow" .. name, { fg = comment_fg, bg = cursorline_bg })
				vim.api.nvim_set_hl(0, "CursorDiagCapL" .. name, { fg = body_bg, bg = cursorline_bg })
				vim.api.nvim_set_hl(0, "CursorDiagCapR" .. name, { fg = body_bg, bg = cursorline_bg })
			end
		end

		vim.schedule(setup_patch_hls)
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.schedule(setup_patch_hls)
			end,
		})

		local _holding = false
		local _uv = vim.uv or vim.loop
		local _hold_timer = _uv.new_timer()
		local last_line = -1

		local function render_cursor_diag()
			local buf = vim.api.nvim_get_current_buf()
			local ok, pos = pcall(vim.api.nvim_win_get_cursor, 0)
			if not ok then
				return
			end
			local line = pos[1] - 1

			local diags = vim.diagnostic.get(buf, { lnum = line })
			if #diags == 0 then
				pcall(vim.api.nvim_buf_del_extmark, buf, ns, diag_id)
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
				id = diag_id,
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
		end

		vim.on_key(function()
			_holding = true
			_hold_timer:stop()
			_hold_timer:start(
				120,
				0,
				vim.schedule_wrap(function()
					_holding = false
					render_cursor_diag()
				end)
			)
		end)

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			callback = function()
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]

				if curr_line ~= last_line then
					pcall(vim.api.nvim_buf_del_extmark, 0, ns, diag_id)
					last_line = curr_line

					if not _holding then
						render_cursor_diag()
					end
				end
			end,
		})

		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function()
				if not _holding then
					render_cursor_diag()
				end
			end,
		})
	end,
}
