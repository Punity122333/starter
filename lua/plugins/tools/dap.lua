return {
	{
		"rcarriga/nvim-dap-ui",
    event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				controls = { enabled = true },
				render = {
					indent = 0,
					max_value_lines = 100,
					expand_lines = false,
				},
				floating = { border = "rounded" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.33 },
							{ id = "breakpoints", size = 0.21 },
							{ id = "stacks", size = 0.21 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 0.26,
						position = "bottom",
					},
				},
			})

			vim.defer_fn(function()
				dapui.update_render({
					indent = 0,    
				})
			end, 0)


			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			-- AUTO REFRESH ALL DAPUI WINDOWS
			local function refresh_dapui()
				pcall(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.bo[buf].filetype
						if ft:match("^dapui") then
							dapui.open({})
							return
						end
					end
				end)
			end

			-- refresh when toggling breakpoints
			local orig_toggle = dap.toggle_breakpoint
			dap.toggle_breakpoint = function(...)
				orig_toggle(...)
				refresh_dapui()
			end

			-- refresh on all debugger updates
			dap.listeners.after.event_stopped["dapui_auto_refresh"] = refresh_dapui
			dap.listeners.after.event_continued["dapui_auto_refresh"] = refresh_dapui
			dap.listeners.after.event_thread["dapui_auto_refresh"] = refresh_dapui
			dap.listeners.after.event_breakpoint["dapui_auto_refresh"] = refresh_dapui

			-- underline heading
			vim.api.nvim_set_hl(0, "DapUIWinbarTitle", {
				fg = "#7dcfff",
				bg = "#1a1b26",
				underline = false,
				bold = true,
			})

			local titles = {
				scopes = " SCOPES - ",
				breakpoints = " BREAKPOINTS - ",
				stacks = " STACKS - ",
				watches = " WATCHES - ",
				console = " CONSOLE - ",
				repl = " REPL - ",
			}

			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function(args)
					local win = vim.api.nvim_get_current_win()
					local name = vim.api.nvim_buf_get_name(args.buf):lower()

					for key, title in pairs(titles) do
						if name:match(key) then
							vim.wo[win].winbar = "%#DapUIWinbarTitle#" .. title

							vim.wo[win].signcolumn = "no"
							vim.wo[win].number = false
							vim.wo[win].relativenumber = false
							vim.wo[win].cursorline = false
							vim.wo[win].foldcolumn = "0"
							break
						end
					end

					local bg = "#1a1b26"
					vim.wo[win].winhighlight = "Normal:Normal,NormalFloat:Normal,EndOfBuffer:Normal,WinBar:Normal"

					local dap_hls = {
						"DapUIScope",
						"DapUIType",
						"DapUIDecoration",
						"DapUIThread",
						"DapUIWatchesHeader",
						"DapUIWatchesEmpty",
						"DapUIWatchesValue",
						"DapUIWatchesError",
						"DapUIBreakpointsPath",
						"DapUIBreakpointsLine",
						"DapUIBreakpointsInfo",
						"DapUIBreakpointsFunctionName",
						"DapUIBreakpointsCurrentLine",
						"DapUIStoppedThread",
						"DapUIFrameName",
						"DapUISource",
						"DapUILineNumber",
						"DapUIFloatBorder",
						"DapUIModifiedValue",
						"DapUIVariable",
						"DapUINormalNC",
						"DapUIPlayPause",
						"DapUIRestart",
						"DapUIStop",
						"DapUIStepOver",
						"DapUIStepInto",
						"DapUIStepBack",
						"DapUIStepOut",
						"DapUIEndofBuffer",
					}

					for _, g in ipairs(dap_hls) do
						local ok, existing = pcall(vim.api.nvim_get_hl, 0, { name = g, link = false })
						if ok then
							vim.api.nvim_set_hl(0, g, vim.tbl_extend("force", existing, { bg = bg }))
						end
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
				callback = function(args)
					local name = vim.api.nvim_buf_get_name(args.buf):lower()

					for key in pairs(titles) do
						if name:match(key) then
							vim.wo.cursorline = (args.event == "WinEnter")
						end
					end
				end,
			})
		end,
	},
}
