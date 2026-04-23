-- Scrub augroup handle — nil when no session is active
local _scrub_aug = nil

-- Core scrubber: wipe virt_text from every extmark in the active session's namespace.
-- Preserves position tracking (end_row/end_col/hl_group) so mini.snippets keeps functioning.
local function clear_session_virt_text()
	local ok, ms = pcall(require, "mini.snippets")
	if not ok then return end
	local session = ms.session.get()
	if not session then return end
	local bufnr = vim.api.nvim_get_current_buf()
	local ns_id = session.ns_id
	for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })) do
		local id, row, col, d = mark[1], mark[2], mark[3], mark[4]
		if d.virt_text and #d.virt_text > 0 then
			vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, col, {
				id      = id,
				virt_text = {},
				end_row = d.end_row,
				end_col = d.end_col,
				hl_group = d.hl_group,
			})
		end
	end
end
-- Schedule a clear to run AFTER any pending vim.schedule() calls from mini.snippets.
-- mini.snippets queues its redraws via vim.schedule; by scheduling ourselves at the
-- same point we'll always be enqueued after it (FIFO), so we always win the race.
local function scheduled_clear()
	vim.schedule(clear_session_virt_text)
end

-- Spin up buffer-local autocmds that fire clear_session_virt_text after every event
-- that can cause mini.snippets to re-render its virt_text bullets:
--   • TextChangedI  – the root cause of the let~/linked-tabstop regression:
--                     mini.snippets' own TextChangedI handler re-draws bullets on
--                     unvisited empty tabstops whenever the current tabstop changes.
--   • MiniSnippetsSessionJump   – mini.snippets redraws after every tabstop jump.
--   • MiniSnippetsSessionResume – redraws when a nested session pops back.
local function setup_scrub(bufnr)
	if _scrub_aug then
		pcall(vim.api.nvim_del_augroup_by_id, _scrub_aug)
	end
	_scrub_aug = vim.api.nvim_create_augroup("MiniSnippetsVirtScrub", { clear = true })

	-- Buffer-scoped so we never fire in unrelated windows
	vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI" }, {
		group   = _scrub_aug,
		buffer  = bufnr,
		callback = scheduled_clear,
	})
	-- User events aren't buffer-scoped by the API but clear_session_virt_text
	-- already guards with ms.session.get(), so false positives are harmless.
	vim.api.nvim_create_autocmd("User", {
		group   = _scrub_aug,
		pattern = { "MiniSnippetsSessionJump", "MiniSnippetsSessionResume" },
		callback = scheduled_clear,
	})
end

local function teardown_scrub()
	if _scrub_aug then
		pcall(vim.api.nvim_del_augroup_by_id, _scrub_aug)
		_scrub_aug = nil
	end
end

-- Still export for blink.cmp's use
package.loaded["mini_snippets_utils"] = { clear_virt_text = clear_session_virt_text }

return {
	"nvim-mini/mini.snippets",
	lazy = false,
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local snips = require("mini.snippets")
		local friendly_dir = require("lazy.core.config").plugins["friendly-snippets"].dir

		-- Nuke all MiniSnippets highlight groups so they render invisibly
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

		-- MiniSnippetsSessionStart fires AFTER default_insert has placed all extmarks
		-- and drawn the initial virt_text, so a scheduled_clear() here reliably wins.
		vim.api.nvim_create_autocmd("User", {
			pattern  = "MiniSnippetsSessionStart",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				setup_scrub(bufnr)
				scheduled_clear() -- wipe the initial bullets
			end,
		})

		-- SessionStop fires BEFORE the session is fully torn down.
		-- Schedule the teardown check so ms.session.get() reflects the post-stop state.
		-- If nested sessions are still alive, keep the autocmds running.
		vim.api.nvim_create_autocmd("User", {
			pattern  = "MiniSnippetsSessionStop",
			callback = function()
				vim.schedule(function()
					local ok, ms = pcall(require, "mini.snippets")
					if not ok or not ms.session.get() then
						teardown_scrub()
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





