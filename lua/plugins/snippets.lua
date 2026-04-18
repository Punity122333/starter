-- Shared helper: strip virt_text from session extmarks without breaking position tracking
-- mini.snippets re-draws dots on every jump, so vim.schedule ensures we run AFTER it
local function clear_session_virt_text()
	vim.schedule(function()
		local ok, ms = pcall(require, "mini.snippets")
		if not ok then return end
		local session = ms.session.get()
		if not session then return end
		local bufnr = vim.api.nvim_get_current_buf()
		local ns_id = session.ns_id
		for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })) do
			local id, row, col, d = mark[1], mark[2], mark[3], mark[4]
			if d.virt_text and #d.virt_text > 0 then
				-- Update extmark in-place: wipe virt_text but preserve position/hl for tracking
				vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, col, {
					id = id,
					virt_text = {},
					end_row = d.end_row,
					end_col = d.end_col,
					hl_group = d.hl_group,
				})
			end
		end
	end)
end

-- Make it accessible to blink-cmp without using _G hacks
package.loaded["mini_snippets_utils"] = { clear_virt_text = clear_session_virt_text }

return {
	"nvim-mini/mini.snippets",
	lazy = false,
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local snips = require("mini.snippets")
		local friendly_dir = require("lazy.core.config").plugins["friendly-snippets"].dir

		local hl_groups = {
			"MiniSnippetsCurrent",
			"MiniSnippetsCurrentReplace",
			"MiniSnippetsFinal",
			"MiniSnippetsUnvisited",
			"MiniSnippetsVisited",
		}
		local function clear_hl()
			for _, hl in ipairs(hl_groups) do
				vim.api.nvim_set_hl(0, hl, {})
			end
		end
		clear_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_hl })

		snips.setup({
			snippets = {
				snips.gen_loader.from_lang({ path = friendly_dir .. "/snippets" }),
				snips.gen_loader.from_lang({ path = "~/.config/nvim/snippets" }),
				snips.gen_loader.from_lang(),
			},
			expand = {
				-- Covers the <C-j> native expand path
				insert = function(snippet, opts)
					snips.default_insert(snippet, opts)
					clear_session_virt_text()
				end,
			},
		})
	end,
}



