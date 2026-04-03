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

local _i_up = vim.api.nvim_replace_termcodes("<C-o><C-y><C-o><C-y><C-o><C-y>", true, false, true)
local _i_down = vim.api.nvim_replace_termcodes("<C-o><C-e><C-o><C-e><C-o><C-e>", true, false, true)
local _i_hleft = vim.api.nvim_replace_termcodes("<C-o>6zh", true, false, true)
local _i_hright = vim.api.nvim_replace_termcodes("<C-o>6zl", true, false, true)

for _, dir in ipairs({ "Up", "Down" }) do
	local dv = dir == "Up" and 3 or -3
	local iseq = dir == "Up" and _i_up or _i_down
	local fn = function()
		queue_scroll(dv, 0)
	end
	local i_fn = function()
		_scroll_ts = _uv.now()
		vim.api.nvim_feedkeys(iseq, "m", false)
	end
	for _, mult in ipairs({ "", "2-", "3-", "4-" }) do
		local lhs = "<" .. mult .. "ScrollWheel" .. dir .. ">"
		vim.keymap.set({ "n", "v" }, lhs, fn, _sv)
		vim.keymap.set("i", lhs, i_fn, _sv)
	end
end

for _, dir in ipairs({ "Left", "Right" }) do
	local dh = dir == "Right" and 6 or -6
	local iseq = dir == "Right" and _i_hright or _i_hleft
	local fn = function()
		queue_scroll(0, dh)
	end
	local i_fn = function()
		_scroll_ts = _uv.now()
		vim.api.nvim_feedkeys(iseq, "m", false)
	end
	for _, mult in ipairs({ "", "2-", "3-", "4-" }) do
		local lhs = "<" .. mult .. "ScrollWheel" .. dir .. ">"
		vim.keymap.set({ "n", "v" }, lhs, fn, _sv)
		vim.keymap.set("i", lhs, i_fn, _sv)
	end
end
local _lm_raw = vim.api.nvim_replace_termcodes("<LeftMouse>", true, false, true)
vim.keymap.set({ "n", "v" }, "<LeftMouse>", function()
---@diagnostic disable-next-line: empty-block
	if _uv.now() - _scroll_ts < SCROLL_DEBOUNCE_MS then
	end
	vim.api.nvim_feedkeys(_lm_raw, "n", false)
end, _sv)
--
-- local function tc(s)
-- 	return vim.api.nvim_replace_termcodes(s, true, false, true)
-- end
--
-- local function feed(s)
-- 	vim.api.nvim_feedkeys(tc(s), "in", false)
-- end
--
-- local function read_digits(first)
-- 	local out = first or ""
-- 	while true do
-- 		local c = vim.fn.getcharstr()
-- 		if not c:match("%d") then
-- 			feed(c)
-- 			break
-- 		end
-- 		out = out .. c
-- 	end
-- 	return out
-- end
--
-- local function read_until_cr()
-- 	local out = ""
-- 	while true do
-- 		local c = vim.fn.getcharstr()
-- 		if c == "\r" then
-- 			break
-- 		end
-- 		out = out .. c
-- 	end
-- 	return out
-- end
--
-- local function read_target()
-- 	local c1 = vim.fn.getcharstr()
--
-- 	if c1:match("%d") then
-- 		return c1 .. read_digits()
-- 	end
--
-- 	if c1 == "+" or c1 == "-" then
-- 		local c2 = vim.fn.getcharstr()
-- 		if c2:match("%d") then
-- 			return c1 .. c2 .. read_digits()
-- 		end
-- 		feed(c2)
-- 		return c1
-- 	end
--
-- 	if c1 == "'" then
-- 		local m = vim.fn.getcharstr()
-- 		return "'" .. m
-- 	end
--
-- 	if c1 == "/" or c1 == "?" then
-- 		local p = read_until_cr()
-- 		return c1 .. p
-- 	end
--
-- 	if c1 == "g" then
-- 		local c2 = vim.fn.getcharstr()
-- 		if c2 == "g" then
-- 			return "0"
-- 		end
-- 		feed(c2)
-- 		return nil
-- 	end
--
-- 	if c1 == "G" then
-- 		return "$"
-- 	end
--
-- 	if c1 == "." or c1 == "$" then
-- 		return c1
-- 	end
--
-- 	return nil
-- end
--
-- vim.keymap.set("n", "\\\\", function()
-- 	local t = read_target()
-- 	if not t then
-- 		return
-- 	end
-- 	feed("<Cmd>silent! move " .. t .. "<CR>")
-- end, { noremap = true, silent = true, nowait = true })
--
-- -- visual mode
-- vim.keymap.set("x", "\\\\", function()
-- 	local t = read_target()
-- 	if not t then
-- 		return
-- 	end
-- 	feed("<Cmd>silent! move " .. t .. "<CR>")
-- end, { noremap = true, silent = true, nowait = true })
