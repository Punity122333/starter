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

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

vim.keymap.set("t", "<Esc>", function()
    vim.cmd("stopinsert")
end, { noremap = true, silent = true })

vim.keymap.set("n", "g\\", function()
    local lines = {}
    for _ = 1, vim.v.count1 do
        lines[#lines + 1] = ""
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
end, { silent = true, desc = "Put blank line(s) below" })

vim.keymap.set("n", "g/", function()
    local count = vim.v.count1
    local lines = {}
    for _ = 1, count do
        lines[#lines + 1] = ""
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + count, 0 })
end, { silent = true, desc = "Put blank line(s) below and jump to last" })

local function jump_todo(direction)
    local regex = [[\v<(TODO|FIXME|HACK)\c]]
    local flags = direction == "next" and "w" or "bw"
    local start_pos = vim.fn.getpos(".")
    local seen = {}

    while true do
        local stop_line = vim.fn.search(regex, flags)

        if stop_line == 0 then
            break
        end

        local cur = vim.fn.getpos(".")
        local key = cur[2] .. "," .. cur[3]

        if seen[key] then
            vim.fn.setpos(".", start_pos)
            break
        end
        seen[key] = true

        local node = vim.treesitter.get_node()
        if node and node:type():find("comment") then
            break
        end
    end
end

vim.keymap.set("n", "]o", function()
    jump_todo("next")
end, { silent = true, desc = "Next todo comment" })

vim.keymap.set("n", "[o", function()
    jump_todo("prev")
end, { silent = true, desc = "Prev todo comment" })

vim.keymap.set("n", "<leader>md", "dm<leader>", { desc = "Clear all marks" })
vim.keymap.set("n", "<leader>ml", "dM<leader>", { desc = "Clear local marks" })

vim.keymap.set("i", "<C-f>", "<C-t>", { desc = "Indent line" })
vim.keymap.set("o", "f", "f", { remap = true })

vim.keymap.set("i", "<BS>", "<C-g>u<BS>", { noremap = true })

vim.keymap.del("n", "hi", {})
