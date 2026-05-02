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

local cmd = vim.api.nvim_create_user_command
local opts = {}

cmd("BrowseMain", function()
    require("browse").browse()
end, opts)
cmd("BrowseInput", function()
    require("browse").input_search()
end, opts)
cmd("BrowseBookmarks", function()
    require("browse").open_manual_bookmarks()
end, opts)
cmd("BrowseDevDocs", function()
    require("browse.devdocs").search()
end, opts)
cmd("BrowseDevDocsFT", function()
    require("browse.devdocs").search_with_filetype()
end, opts)
cmd("BrowseMDN", function()
    require("browse.mdn").search()
end, opts)
