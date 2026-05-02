local telescope = require("telescope")

telescope.load_extension("emoji")

vim.keymap.set("n", "<leader>se", telescope.extensions.emoji.emoji, { desc = "Search Emojis" })

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

local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { desc = desc, silent = true })
end

map("<leader>ff", nav_call("files"), "Files (fd)")
map("<leader>fb", nav_call("buffers"), "Buffers")
map("<leader>f'", nav_call("marks"), "Marks")
map("<leader>fr", nav_call("references"), "LSP References")
map("<leader>fo", nav_call("oldfiles"), "Recent Files")
map("<leader>fp", nav_call("projects"), "Projects")
map("<leader>fg", nav_call("git_files"), "Git files")
map("<leader>fc", nav_call("config_files"), "Config files")
map("<leader>fB", nav_call("all_buffers"), "All buffers")

map("<leader>fd", function()
    require("snipe.nav").diagnostics(false)
end, "Diagnostics (Buffer)")
map("<leader>f;", function()
    require("snipe.nav").diagnostics(true)
end, "Diagnostics (Workspace)")
map("<leader>sd", function()
    require("snipe.nav").diagnostics(false)
end, "Diagnostics (Buffer)")
map("<leader>sD", function()
    require("snipe.nav").diagnostics(true)
end, "Diagnostics (Workspace)")

map("<leader>sa", search_call("autocmds"), "Autocmds")
map("<leader>sc", search_call("cmdhistory"), "Command History")
map("<leader>sC", search_call("commands"), "Commands")
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
map("<leader>sB", search_call("lsp_symbols"), "LSP Symbols")
map("<leader>sP", search_call("pickers"), "Builtin Pickers")
map("<leader>s\"", search_call("registers"), "Registers")
map("<leader>s/", search_call("searchhistory"), "Search History")
map("<leader>sn", search_call("noice"), "Noice History")
map("<leader>sg", rg_call("rg"), "Grep (Root)")
map("<leader>s.", rg_call("rg"), "Grep (CWD)")
map("<leader>sb", rg_call("rg_buffer"), "Search Buffer")
map("<leader>fw", rg_call("rg"), "Grep (Fast)")
vim.keymap.set("n", "<leader>/", rg_call("rg"), { desc = "Grep (Root)", remap = true })

map("<leader>sw", function()
    require("snipe.search").grep_word(true)
end, "Grep Word (Root)")
map("<leader>sW", function()
    require("snipe.search").grep_word(false)
end, "Grep Word (CWD)")

vim.keymap.set("n", "<leader>fD", function()
    Snacks.picker.files({
        cwd = vim.fn.expand("~"),
        hidden = true,
        ignored = false,
        title = "Home Search",
        exclude = { "node_modules", ".git", ".cache", "__pycache__", ".venv", "venv", "build", "dist" },
    })
end, { desc = "Search from Home Directory" })

vim.keymap.set("n", "<leader>fx", function()
    Snacks.explorer.reveal()
end, { desc = "Reveal Current File in Explorer" })

vim.keymap.set("n", "<leader>sf", function()
    require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Grug Far: Current File" })

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
