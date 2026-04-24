-- Intercept nvim_buf_set_extmark at the API level to strip virt_text for the
-- active mini.snippets namespace. This is the only race-free approach: instead
-- of scheduling a cleanup AFTER mini.snippets draws, we prevent the draw at all.
-- Overhead is one integer comparison per extmark set — negligible.
local _patched_ns = nil -- set to session.ns_id while a session is live

local _orig_set_extmark = vim.api.nvim_buf_set_extmark
---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_buf_set_extmark = function(bufnr, ns_id, row, col, opts)
	if _patched_ns and ns_id == _patched_ns and opts.virt_text and #opts.virt_text > 0 then
		opts = vim.tbl_extend("force", opts, { virt_text = {}, virt_text_pos = nil })
	end
	return _orig_set_extmark(bufnr, ns_id, row, col, opts)
end

-- Scrub any virt_text that snuck in before the patch was active (i.e. the very
-- first frame after SessionStart, before our autocmd fires).
local function scrub_existing(session, bufnr)
	local ns_id = session.ns_id
	for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })) do
		local id, row, col, d = mark[1], mark[2], mark[3], mark[4]
		if d.virt_text and #d.virt_text > 0 then
			_orig_set_extmark(bufnr, ns_id, row, col, {
				id        = id,
				virt_text = {},
				end_row   = d.end_row,
				end_col   = d.end_col,
				hl_group  = d.hl_group,
			})
		end
	end
end

return {
	"nvim-mini/mini.snippets",
	lazy = false,
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local snips = require("mini.snippets")
		local friendly_dir = require("lazy.core.config").plugins["friendly-snippets"].dir

		-- Nuke all MiniSnippets highlight groups so nothing renders even if a
		-- virt_text somehow slips through (belt-and-suspenders).
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

		-- Activate the patch as soon as a session starts, then do a one-shot scrub
		-- for any extmarks already placed before we got here.
		vim.api.nvim_create_autocmd("User", {
			pattern  = "MiniSnippetsSessionStart",
			callback = function()
				local ok, ms = pcall(require, "mini.snippets")
				if not ok then return end
				local session = ms.session.get()
				if not session then return end
				_patched_ns = session.ns_id
				local bufnr = vim.api.nvim_get_current_buf()
				-- Run immediately AND after one schedule tick to catch anything
				-- mini.snippets deferred from inside default_insert.
				scrub_existing(session, bufnr)
				vim.schedule(function()
					local s = ms.session.get()
					if s then scrub_existing(s, bufnr) end
				end)
			end,
		})

		-- On stop: scrub leftover extmarks (e.g. session killed mid-snippet by
		-- deleting the text), then deactivate the patch if no sessions remain.
		vim.api.nvim_create_autocmd("User", {
			pattern  = "MiniSnippetsSessionStop",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				-- The session is still accessible at this point — scrub before it's gone.
				local ok, ms = pcall(require, "mini.snippets")
				if ok then
					local session = ms.session.get()
					if session then scrub_existing(session, bufnr) end
				end
				-- Deactivate patch after teardown completes (session.get() → nil).
				vim.schedule(function()
					if not ok or not ms.session.get() then
						_patched_ns = nil
					end
				end)
			end,
		})

		snips.setup({
			snippets = {
				snips.gen_loader.from_lang({ path = friendly_dir .. "/snippets" }),
				snips.gen_loader.from_lang({ path = vim.fn.expand("~/.config/nvim/snippets") }),
				snips.gen_loader.from_lang(),
			},
		})
	end,
}






