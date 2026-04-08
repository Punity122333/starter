local hover_win = nil
local hover_pending = false
local _any_float_open = false

local function get_sig_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if ft == "lsp_signature" or ft == "noice" then
				return win
			end
		end
	end
	return nil
end

local function get_active_popup()
	if hover_win and vim.api.nvim_win_is_valid(hover_win) then
		return hover_win
	end
	hover_win = nil
	return get_sig_win()
end

local function dismiss_all()
	if hover_win and vim.api.nvim_win_is_valid(hover_win) then
		pcall(vim.api.nvim_win_close, hover_win, true)
	end
	hover_win = nil
	hover_pending = false
	_any_float_open = false
	pcall(function()
		require("noice").cmd("dismiss")
	end)
end

local function show_lsp_info()
	if hover_pending then
		return
	end
	hover_pending = true

	local bufnr = vim.api.nvim_get_current_buf()
	local word = vim.fn.expand("<cword>")
	local byte_count = #word

	local hover_clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
	local sig_clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/signatureHelp" })

	local encoding = (hover_clients[1] or sig_clients[1] or {}).offset_encoding or "utf-16"
	local params = vim.lsp.util.make_position_params(0, encoding)

	local all_lines = {}

	local function trim_blank_edges(t)
		while #t > 0 and t[1] == "" do
			table.remove(t, 1)
		end
		while #t > 0 and t[#t] == "" do
			table.remove(t)
		end
	end

	local function append(lines)
		trim_blank_edges(lines)
		if #lines == 0 then
			return
		end
		if #all_lines > 0 then
			table.insert(all_lines, "")
		end
		vim.list_extend(all_lines, lines)
	end

	local function open_popup()
		hover_pending = false
		trim_blank_edges(all_lines)
		if #all_lines == 0 then
			return
		end
		for i, line in ipairs(all_lines) do
			all_lines[i] = " " .. line .. " "
		end
		local _, new_win = vim.lsp.util.open_floating_preview(all_lines, "markdown", {
			border = "rounded",
			focus = false,
			max_width = 80,
			max_height = 20,
			wrap = true,
			stylize_markdown = true,
			close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertCharPre" },
		})
		if new_win and vim.api.nvim_win_is_valid(new_win) then
			hover_win = new_win
			_any_float_open = true
			vim.api.nvim_set_option_value("conceallevel", 3, { win = new_win })
			vim.api.nvim_set_option_value("spell", false, { win = new_win })
			vim.api.nvim_create_autocmd("WinClosed", {
				pattern = tostring(new_win),
				once = true,
				callback = function()
					hover_win = nil
					_any_float_open = false
				end,
			})
		end
	end

	local pending = 0
	if #hover_clients > 0 then
		pending = pending + 1
	end
	if #sig_clients > 0 then
		pending = pending + 1
	end

	local function done_one()
		pending = pending - 1
		if pending == 0 then
			if byte_count > 0 then
				if #all_lines > 0 then
					table.insert(all_lines, "")
					table.insert(all_lines, "---")
				end
				table.insert(all_lines, string.format("**%d bytes**", byte_count))
			end
			vim.schedule(open_popup)
		end
	end

	if #hover_clients > 0 then
		local called = false
		vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result)
			if called then
				return
			end
			called = true
			if not err and result and result.contents then
				local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
				append(lines)
			end
			done_one()
		end)
	end

	if #sig_clients > 0 then
		local called = false
		vim.lsp.buf_request(bufnr, "textDocument/signatureHelp", params, function(err, result)
			if called then
				return
			end
			called = true
			if not err and result and result.signatures and #result.signatures > 0 then
				local active_idx = (result.activeSignature or 0) + 1
				local sig = result.signatures[active_idx] or result.signatures[1]
				if sig then
					local sig_lines = { "```", sig.label, "```" }
					if sig.documentation then
						local doc = type(sig.documentation) == "table" and sig.documentation.value
							or tostring(sig.documentation)
						if doc ~= "" then
							table.insert(sig_lines, "")
							vim.list_extend(sig_lines, vim.split(doc, "\n", { plain = true }))
						end
					end
					append(sig_lines)
				end
			end
			done_one()
		end)
	end

	if pending == 0 then
		done_one = function() end
		hover_pending = false
		if byte_count > 0 then
			table.insert(all_lines, string.format("**%d bytes**", byte_count))
		end
		vim.schedule(open_popup)
	end
end

return {
	"folke/noice.nvim",
	lazy = false,
	opts = {
		presets = {
			lsp_doc_border = true,
		},

		lsp = {
			progress = {
				enabled = false,
			},
			signature = {
				enabled = true,
				auto_open = {
					enabled = false,
				},
				border = {
					style = "rounded",
				},
			},
		},
		views = {
			popup = {
				border = {
					style = "rounded",
				},
				win_options = {
					winhighlight = {
						Normal = "NoicePopup",
						FloatBorder = "NoicePopupBorder",
					},
				},
			},
			cmdline_popup = {
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
			},
		},
		routes = {
			{
				filter = {
					any = {
						{ find = "attempt to yield across C-call boundary" },
						{ find = "languagetree.lua" },
						{ find = "tree_sitter_markdown_parse_code_blocks" },
						{ find = "semanticTokensProvider" },
						{ find = "semantic_tokens.lua" },
						{ find = "shared.lua" },
						{ find = "Invalid window" },
						{ find = "selected model" },
						{ find = "Using previously selected model" },
						{ find = "Using" },
						{ find = "with warnings" },
						{ find = "repo map" },
						{ find = "lines indented" },
						{ find = "lines moved" },
						{ find = "nvim_buf_set_extmark" },
						{ find = "clipboard" },
						{ find = "promise" },
						{ find = "split" },
						{ find = "modifiable" },
						{ find = "decoding suggestions" },
						{ find = "<ed" },
					},
				},
				opts = { skip = true },
			},
		},
	},
	config = function(_, opts)
		require("noice").setup(opts)

		local function is_in_function_call()
			local node = vim.treesitter.get_node()
			while node do
				local t = node:type()
				if t == "arguments" or t == "parameter_list" or t == "argument_list" then
					return true
				end
				node = node:parent()
			end
			return false
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("MarkdownConceal", { clear = true }),
			pattern = "markdown",
			callback = function(ev)
				local win = vim.fn.bufwinid(ev.buf)
				if win ~= -1 then
					local cfg = vim.api.nvim_win_get_config(win)
					if cfg.relative == "" then
						vim.api.nvim_set_option_value("conceallevel", 0, { win = win })
					end
				end
			end,
		})

		local _sig_close_timer = nil
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = vim.api.nvim_create_augroup("SignatureAutoClose", { clear = true }),
			callback = function()
				-- O(1) check — no window scan, no allocations
				if not _any_float_open then
					return
				end
				if _sig_close_timer then
					_sig_close_timer:stop()
					_sig_close_timer:close()
					_sig_close_timer = nil
				end
				_sig_close_timer = vim.uv.new_timer()
				_sig_close_timer:start(
					60,
					0,
					vim.schedule_wrap(function()
						if _sig_close_timer then
							_sig_close_timer:close()
							_sig_close_timer = nil
						end
						for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
							if client.progress and not vim.tbl_isempty(client.progress) then
								return
							end
						end
						if get_sig_win() and not is_in_function_call() then
							require("noice").cmd("dismiss")
						end
					end)
				)
			end,
		})
	end,
	keys = {
		{
			"<C-;>",
			function()
				if get_active_popup() then
					dismiss_all()
				else
					show_lsp_info()
				end
			end,
			mode = { "i", "n" },
			desc = "Toggle LSP info (hover / signature / bytes)",
		},
	},
}
