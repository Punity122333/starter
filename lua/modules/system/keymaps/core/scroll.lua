local _scroll_ts = 0
local _move_ts = 0
local SCROLL_DEBOUNCE_MS = 120
local _sv = { noremap = true, silent = true }
local _uv = vim.uv or vim.loop
local _pending_v = 0
local _pending_h = 0
local _flush_sched = false

local function apply_scroll(dv, dh)
    local view = vim.fn.winsaveview()

    if dv ~= 0 then
        view.topline = math.max(1, view.topline - dv)

        local winheight = vim.fn.winheight(0)
        local so = vim.o.scrolloff
        local top_limit = view.topline + so
        local bot_limit = view.topline + winheight - 1 - so

        if top_limit > bot_limit then
            view.lnum = view.topline + math.floor(winheight / 2)
        else
            view.lnum = math.max(top_limit, math.min(bot_limit, view.lnum))
        end
    end

    if dh ~= 0 then
        view.leftcol = math.max(0, view.leftcol + dh)
    end

    local ei = vim.o.eventignore
    vim.o.eventignore = "all"
    vim.fn.winrestview(view)
    vim.o.eventignore = ei
end

local function flush_scroll()
    _flush_sched = false
    local dv, dh = _pending_v, _pending_h
    _pending_v, _pending_h = 0, 0
    if dv == 0 and dh == 0 then
        return
    end
    apply_scroll(dv, dh)
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
        apply_scroll(dv, 0)
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
        apply_scroll(0, dh)
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

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained" }, {
    callback = function()
        _scroll_ts = _uv.now()
    end,
})
