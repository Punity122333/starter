local COMMAND_SAVE_AND_QUIT = "WQ"
local COMMAND_SAVE_AND_QUIT_ALT1 = "Wq"
local COMMAND_SAVE_AND_QUIT_ALL = "WQA"
local COMMAND_SAVE_AND_QUIT_ALL_ALT1 = "Wqa"

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

local _scroll_ts         = 0
local SCROLL_DEBOUNCE_MS = 120
local _sv                = { noremap = true, silent = true }
local _uv                = vim.uv or vim.loop

local _pending_v         = 0
local _pending_h         = 0
local _flush_sched       = false

local function flush_scroll()
    _flush_sched = false
    local v, h = _pending_v, _pending_h
    _pending_v, _pending_h = 0, 0
    if v == 0 and h == 0 then return end
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

local _i_up     = vim.api.nvim_replace_termcodes("<C-o><C-y><C-o><C-y><C-o><C-y>", true, false, true)
local _i_down   = vim.api.nvim_replace_termcodes("<C-o><C-e><C-o><C-e><C-o><C-e>", true, false, true)
local _i_hleft  = vim.api.nvim_replace_termcodes("<C-o>6zh", true, false, true)
local _i_hright = vim.api.nvim_replace_termcodes("<C-o>6zl", true, false, true)

for _, dir in ipairs({ "Up", "Down" }) do
    local dv   = dir == "Up" and 3 or -3
    local iseq = dir == "Up" and _i_up or _i_down
    local fn   = function() queue_scroll(dv, 0) end
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
    local dh   = dir == "Right" and 6 or -6
    local iseq = dir == "Right" and _i_hright or _i_hleft
    local fn   = function() queue_scroll(0, dh) end
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
    if _uv.now() - _scroll_ts < SCROLL_DEBOUNCE_MS then
    end
    vim.api.nvim_feedkeys(_lm_raw, "n", false)
end, _sv)

vim.keymap.set("v", ">", function()
    local saved = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.cmd("normal! >")
    vim.cmd("normal! gv")
    vim.o.lazyredraw = saved
end, { noremap = true, silent = true, desc = "Indent and reselect" })

vim.keymap.set("v", "<", function()
    local saved = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.cmd("normal! <")
    vim.cmd("normal! gv")
    vim.o.lazyredraw = saved
end, { noremap = true, silent = true, desc = "Unindent and reselect" })

vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move cursor left", silent = true })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move cursor down", silent = true })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move cursor up", silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move cursor right", silent = true })

vim.keymap.set("n", "<leader>fv", function()
    Snacks.terminal(nil, { win = { position = "right", width = 0.25 } })
end, { desc = "Terminal Vertical (Right)" })
vim.keymap.set("n", "<leader>fV", function()
    Snacks.terminal(nil, { win = { position = "left", width = 0.25 } })
end, { desc = "Terminal Vertical (Left)" })
vim.keymap.set("n", "<leader>ti", ":lua require('image').toggle()<CR>", { desc = "Toggle Images" })
vim.keymap.set("n", "<leader>br", function()
    Snacks.bufdelete()
end, { desc = "Remove Current Buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })

vim.keymap.set("n", "<A-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

vim.keymap.set("n", "<leader>fD", function()
    Snacks.picker.files({
        cwd = vim.fn.expand("~"),
        hidden = true,
        ignored = false,
        title = "Home Search",
        exclude = { "node_modules", ".git", ".cache", "__pycache__", ".venv", "venv", "build", "dist" },
    })
end, { desc = "Search Home" })

vim.keymap.set("n", "<leader>fx", function()
    Snacks.explorer.reveal()
end, { desc = "Reveal Current File in Explorer" })
vim.keymap.del("n", "<leader>gg")

vim.keymap.set("n", "<leader>pv", "<cmd>vsplit | term<cr>a", { desc = "Terminal Vertical Split" })
vim.keymap.set("n", "<leader>ph", "<cmd>split | term<cr>a", { desc = "Terminal Horizontal Split" })
vim.keymap.set("n", "<leader>pdf", ":silent !zathura <cfile> &<CR>", { desc = "Open PDF in Zathura" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

vim.keymap.set("n", "<leader>uN", function()
    local rn = not vim.wo.relativenumber
    vim.wo.relativenumber = rn
    vim.notify(rn and "Relative numbers" or "Absolute numbers", vim.log.levels.INFO)
end, { desc = "Toggle relative/absolute line numbers" })

vim.api.nvim_create_user_command("TSRestart", function()
    local buf = vim.api.nvim_get_current_buf()
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if lang then
        vim.treesitter.stop(buf)
        vim.treesitter.start(buf, lang)
        vim.notify("Treesitter restarted for: " .. lang, vim.log.levels.INFO)
    else
        vim.notify("No Treesitter parser for this filetype", vim.log.levels.WARN)
    end
end, { desc = "Restart Treesitter for current buffer" })

local function wrap_saga(cmd)
    return function()
        local bufnr = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(bufnr, false, {
            relative = "editor",
            width = 1,
            height = 1,
            row = 0,
            col = 0,
            style = "minimal",
        })
        vim.cmd("silent! " .. cmd)
        vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, 50)
    end
end

vim.keymap.set("n", "gh", wrap_saga("Lspsaga finder"), { desc = "LSP Finder" })
vim.keymap.set("n", "K", wrap_saga("Lspsaga hover_doc"), { desc = "Hover Docs" })
vim.keymap.set("n", "gjd", wrap_saga("Lspsaga goto_definition"), { desc = "Goto Definition" })
vim.keymap.set("n", "gjt", wrap_saga("Lspsaga peek_type_definition"), { desc = "Peek Type Definition" })
vim.keymap.set("n", "gji", wrap_saga("Lspsaga incoming_calls"), { desc = "Incoming Calls" })
vim.keymap.set("n", "gjo", wrap_saga("Lspsaga outgoing_calls"), { desc = "Outgoing Calls" })
vim.keymap.set("n", "gjn", wrap_saga("Lspsaga diagnostic_jump_next"), { desc = "Next Diagnostic" })
vim.keymap.set("n", "gjp", wrap_saga("Lspsaga diagnostic_jump_prev"), { desc = "Prev Diagnostic" })

vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "LSP Outline" })
vim.keymap.set("n", "gjs", "<cmd>Lspsaga outline<CR>", { desc = "Toggle Outline" })
vim.keymap.set("n", "gjb", "<cmd>Lspsaga symbols_in_winbar<CR>", { desc = "Winbar Symbols" })
vim.keymap.set("n", "gjl", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagnostics" })

pcall(function()
    require("which-key").add({ { "gj", group = "LSP Navigation" } })
end)
vim.keymap.set("n", "<leader>[]", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
    end
    vim.cmd("edit!")
    vim.notify("LSP Clients refreshed for buffer", vim.log.levels.INFO, { title = "LSP Panic" })
end, { desc = "LSP Panic Button (Soft Refresh)" })
vim.keymap.set("n", "<leader>sf", function()
    local grug = require("grug-far")
    grug.open({
        transient = true,
        prefills = {
            paths = vim.fn.expand("%"),
        },
    })
end, { desc = "Grug Far: Current File" })
vim.keymap.set("n", "<leader>md", "dm<leader>", { desc = "Clear all marks" })
vim.keymap.set("n", "<leader>ml", "dm<leader>", { desc = "Clear local marks" })

vim.keymap.set("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Format file manually" })
vim.keymap.set("n", "<leader>mb", ":set list!<CR>", { noremap = true, silent = true, desc = "Toggle listchars" })
vim.keymap.set("i", "<C-f>", "<C-t>", { desc = "Indent line" })
vim.keymap.set("n", "S", function()
    require("flash").treesitter({
        search = { multi_window = false, wrap = true },
        jump = { pos = "start" },
        action = function(match)
            vim.api.nvim_win_set_cursor(match.win, match.pos)
        end,
        label = { before = true, after = false },
    })
end, { desc = "Global Treesitter Jump" })
vim.keymap.set({ "n", "x", "o" }, "<leader>]", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter Visual Selection" })
vim.keymap.set("n", "<leader>uH", function()
    vim.opt.list = not vim.opt.list:get()
    local status = vim.opt.list:get() and "Enabled" or "Disabled"
    vim.notify("Hidden Characters " .. status, vim.log.levels.INFO, {
        title = "UI Toggle",
    })
end, { desc = "Toggle List / NoList" })
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })

local function toggle_lazygit()
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    lazygit:toggle()
end

vim.keymap.set("n", "<leader>\\\\", function()
    toggle_lazygit()
end, { desc = "ToggleTerm Lazygit" })

vim.keymap.set("n", "<leader>gg", function()
    toggle_lazygit()
end, { desc = "ToggleTerm Lazygit" })
vim.keymap.set("n", "<leader>gG", function()
    toggle_lazygit()
end, { desc = "ToggleTerm Lazygit" })
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>t<Up>", "<cmd>ToggleTerm direction=horizontal<cr>", opts)
vim.keymap.set("n", "<leader>t<Down>", "<cmd>ToggleTerm direction=horizontal<cr>", opts)

vim.keymap.set("n", "<leader>t<Left>", "<cmd>ToggleTerm direction=vertical<cr>", opts)
vim.keymap.set("n", "<leader>t<Right>", "<cmd>ToggleTerm direction=vertical<cr>", opts)

vim.keymap.set("o", "f", "f", { remap = true })
pcall(vim.keymap.del, "n", "<leader>sb")
vim.keymap.set("n", "<leader>sb", function()
    local width = 0.35
    Snacks.picker.lines({
        on_show = function(picker)
            if #picker:filter().search < 2 then
                picker:filter().search = ""
            end
        end,
        layout = {
            preset = "default",
            preview = false,
            layout = {
                backdrop = false,
                row = 0,
                col = 1 - width,
                width = width,
                height = 0.4,
                border = "rounded",
                box = "vertical",
                { win = "input", height = 1,     border = "bottom" },
                { win = "list",  border = "none" },
            },
        },
    })
end, { desc = "Search Current Buffer" })

vim.keymap.set("n", "<leader>rb", "<cmd>edit!<cr>", { desc = "Refresh Buffer" })
local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = "" .. desc, silent = true })
end

local function nav_call(method)
    return function()
        require("snipe.nav")[method]()
    end
end

local function search_call(method)
    return function()
        require("snipe.search")[method]()
    end
end

local function rg_call(method)
    return function()
        require("snipe.rg")[method]()
    end
end

map("<leader>ff", nav_call("files"), "Files (fd)")
map("<leader>fb", nav_call("buffers"), "Buffers")
map("<leader>f'", nav_call("marks"), "Marks")
map("<leader>fr", nav_call("references"), "LSP References")
map("<leader>fo", nav_call("oldfiles"), "Recent Files")
map("<leader>fp", nav_call("projects"), "Projects")
map("<leader>fd", function()
    require("snipe.nav").diagnostics(false)
end, "Diagnostics (Buffer)")
map("<leader>f;", function()
    require("snipe.nav").diagnostics(true)
end, "Diagnostics (Workspace)")
map("<leader>fg", nav_call("git_files"), "Git files")
map("<leader>fc", nav_call("config_files"), "Config files")
map("<leader>fB", nav_call("all_buffers"), "All buffers")
map("<leader>sd", function()
    require("snipe.nav").diagnostics(false)
end, "Diagnostics (Buffer)")
map("<leader>sD", function()
    require("snipe.nav").diagnostics(true)
end, "Diagnostics (Workspace)")
map("<leader>sa", search_call("autocmds"), "Autocmds")
map("<leader>sc", search_call("cmdhistory"), "Command History")
map("<leader>sC", search_call("commands"), "Commands")
map("<leader>sg", rg_call("rg"), "Grep (Root)")
map("<leader>/", rg_call("rg"), "Grep (Root)", { remap = true })
map("<leader>s.", rg_call("rg"), "Grep (CWD)")
map("<leader>sh", search_call("help"), "Help Pages")
map("<leader>sH", search_call("highlights"), "Highlights")
map("<leader>si", search_call("icons"), "Icons")
map("<leader>sj", search_call("jumps"), "Jumps")
map("<leader>sk", search_call("keymaps"), "Keymaps")
map("<leader>sl", search_call("loclist"), "Location List")
map("<leader>sM", search_call("manpages"), "Man Pages")
map("<leader>sp", search_call("plugins"), "Plugin Spec")
map("<leader>sq", search_call("quickfix"), "Quickfix")
map("<leader>su", search_call("undo"), "Undo History")
map("<leader>sb", rg_call("rg_buffer"), "Search Buffer")
map("<leader>sB", search_call("lsp_symbols"), "LSP Symbols")
map("<leader>sP", search_call("pickers"), "Builtin Pickers")
map("<leader>sw", function()
    require("snipe.search").grep_word(true)
end, "Grep Word (Root)")
map("<leader>sW", function()
    require("snipe.search").grep_word(false)
end, "Grep Word (CWD)")
map('<leader>s"', search_call("registers"), "Registers")
map("<leader>s/", search_call("searchhistory"), "Search History")
map("<leader>sn", search_call("noice"), "Noice History")

map("<leader>fw", rg_call("rg"), "Grep (Fast)")
local cmd = vim.api.nvim_create_user_command

cmd("BrowseMain", function()
    require("browse").browse()
end, { desc = "Open browse.nvim main menu" })

cmd("BrowseInput", function()
    require("browse").input_search()
end, { desc = "Search with input prompt" })

cmd("BrowseBookmarks", function()
    require("browse").open_manual_bookmarks()
end, { desc = "Open manual bookmarks" })

cmd("BrowseDevDocs", function()
    require("browse.devdocs").search()
end, { desc = "Search DevDocs" })

cmd("BrowseDevDocsFT", function()
    require("browse.devdocs").search_with_filetype()
end, { desc = "Search DevDocs with current filetype" })

cmd("BrowseMDN", function()
    require("browse.mdn").search()
end, { desc = "Search MDN" })
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

local modes = { "n", "o", "x" }

map(modes, "gkiw", "<cmd>lua require('various-textobjs').subword('inner')<CR>", "Inner Subword")
map(modes, "gkaw", "<cmd>lua require('various-textobjs').subword('outer')<CR>", "Outer Subword")
map(modes, "gkim", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", "Inner Chain Member")
map(modes, "gkam", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", "Outer Chain Member")
map(modes, "gkic", "<cmd>lua require('various-textobjs').column('inner')<CR>", "Inner Column")
map(modes, "gkac", "<cmd>lua require('various-textobjs').column('outer')<CR>", "Outer Column")

map(modes, "gkii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", "Inner Indent")
map(modes, "gkai", "<cmd>lua require('various-textobjs') .indentation('outer', 'outer')<CR>", "Outer Indent")

map(modes, "gkig", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", "Entire Buffer")
map(modes, "gkin", "<cmd>lua require('various-textobjs').nearLine('inner')<CR>", "Near Line")

map(modes, "gkiu", "<cmd>lua require('various-textobjs').url()<CR>", "URL")
map(modes, "gkid", "<cmd>lua require('various-textobjs').diagnostic()<CR>", "Diagnostic")
map(modes, "gkik", "<cmd>lua require('various-textobjs').key('inner')<CR>", "Key")
local wk = require("which-key")

wk.add({
    { "gk",  group = "various-textobjs" },
    { "gki", group = "inner" },
    { "gka", group = "around" },
})

