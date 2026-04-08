local COMMAND_SAVE_AND_QUIT = "WQ"
local COMMAND_SAVE_AND_QUIT_ALT1 = "Wq"
local COMMAND_SAVE_AND_QUIT_ALL = "WQA"
local COMMAND_SAVE_AND_QUIT_ALL_ALT1 = "Wqa"
require("config.keymaps.general_keymaps")
require("config.keymaps.lsp_keymaps")
require("config.keymaps.movement_keymaps")
require("config.keymaps.plugin_keymaps")

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT, function()
	vim.cmd("silent! wall")
	vim.defer_fn(function()
		local ok_autosave, autosave = pcall(require, "auto-save")
		if ok_autosave and autosave then
			vim.g.auto_save_abort = true
		end
		local ok_persist, persistence = pcall(require, "persistence")
		if ok_persist and persistence then
			persistence.save()
		end
		vim.defer_fn(function()
			vim.cmd("qall!")
		end, 100)
	end, 150)
end, { desc = "Save all and quit cleanly" })

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALT1, function()
	vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly", force = true })

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALL, function()
	vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly" })

vim.api.nvim_create_user_command(COMMAND_SAVE_AND_QUIT_ALL_ALT1, function()
	vim.cmd(COMMAND_SAVE_AND_QUIT)
end, { desc = "Save all and quit cleanly" })

vim.cmd([[
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == "wq" ? "WQ" : "wq"
  cnoreabbrev <expr> Wq getcmdtype() == ":" && getcmdline() == "Wq" ? "WQ" : "Wq"
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == "wqa" ? "WQA" : "wqa"
  cnoreabbrev <expr> Wqa getcmdtype() == ":" && getcmdline() == "Wqa" ? "WQA" : "Wqa"
]])

vim.keymap.set("i", "<CR>", "<CR>", { noremap = true })
vim.keymap.set("i", "<BS>", "<BS>", { noremap = true })

local _scroll_ts = 0
local SCROLL_DEBOUNCE_MS = 120
local _sv = { noremap = true, silent = true }
local _uv = vim.uv or vim.loop

local _pending_v = 0
local _pending_h = 0
local _flush_sched = false

local function flush_scroll()
	_flush_sched = false
	local v, h = _pending_v, _pending_h
	_pending_v, _pending_h = 0, 0
	if v == 0 and h == 0 then
		return
	end
	if v ~= 0 then
		vim.cmd("normal! " .. math.abs(v) .. (v > 0 and "\025" or "\005"))
	end
	if h ~= 0 then
		vim.cmd("normal! " .. math.abs(h) .. (h > 0 and "zl" or "zh"))
	end
end

local function queue_scroll(dv, dh)
	_scroll_ts = _uv.now()
	_pending_v = _pending_v + dv
	_pending_h = _pending_h + dh
	if not _flush_sched then
		_flush_sched = true
		vim.schedule(flush_scroll)
	end
end

for _, dir in ipairs({ "Up", "Down" }) do
	local dv = dir == "Up" and 3 or -3
	local fn = function()
		queue_scroll(dv, 0)
	end
	local i_fn = function()
		_scroll_ts = _uv.now()
		local view = vim.fn.winsaveview()
		view.topline = math.max(1, view.topline + (dir == "Up" and -3 or 3))
		vim.fn.winrestview(view)
	end
	for _, mult in ipairs({ "", "2-", "3-", "4-" }) do
		local lhs = "<" .. mult .. "ScrollWheel" .. dir .. ">"
		vim.keymap.set({ "n", "v" }, lhs, fn, _sv)
		vim.keymap.set("i", lhs, i_fn, _sv)
	end
end

for _, dir in ipairs({ "Left", "Right" }) do
	local dh = dir == "Right" and 6 or -6
	local fn = function()
		queue_scroll(0, dh)
	end
	local i_fn = function()
		_scroll_ts = _uv.now()
		local view = vim.fn.winsaveview()
		view.leftcol = math.max(0, view.leftcol + (dir == "Right" and 6 or -6))
		vim.fn.winrestview(view)
	end
	for _, mult in ipairs({ "", "2-", "3-", "4-" }) do
		local lhs = "<" .. mult .. "ScrollWheel" .. dir .. ">"
		vim.keymap.set({ "n", "v" }, lhs, fn, _sv)
		vim.keymap.set("i", lhs, i_fn, _sv)
	end
end

local _lm_raw = vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
vim.keymap.set({ "n", "v" }, "<LeftMouse>", function()
	if _uv.now() - _scroll_ts < SCROLL_DEBOUNCE_MS then
    return
	end
	vim.api.nvim_feedkeys(_lm_raw, "n", false)
end, _sv)

local _j_raw = vim.api.nvim_replace_termcodes("j", true, false, true)
local _k_raw = vim.api.nvim_replace_termcodes("k", true, false, true)
vim.keymap.set({ "n", "v" }, "j", function()
	_move_ts = _uv.now()
	vim.api.nvim_feedkeys(_j_raw, "n", false)
end, _sv)
vim.keymap.set({ "n", "v" }, "k", function()
	_move_ts = _uv.now()
	vim.api.nvim_feedkeys(_k_raw, "n", false)
end, _sv)
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
	callback = function()
		_scroll_ts = _uv.now()
	end,
})
local function jump_todo(direction)
	local search_cmd = direction == "next" and "/" or "?"
	local regex = [[\v<(TODO|FIXME|HACK)>\c]]

	local ok, _ = pcall(vim.cmd, "silent! " .. search_cmd .. regex)

	if ok then
		local node = vim.treesitter.get_node()
		if node and node:type():find("comment") then
			return
		else
			jump_todo(direction)
		end
	end
end

vim.keymap.set("n", "]o", function()
	jump_todo("next")
end, { silent = true, desc = "Next todo comment" })
vim.keymap.set("n", "[o", function()
	jump_todo("prev")
end, { silent = true, desc = "Prev todo comment" })
