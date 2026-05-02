vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "g]", vim.diagnostic.open_float)

vim.keymap.set("n", "<leader>O", function()
    vim.cmd("Outline")
end, { desc = "Open Outline" })

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

vim.keymap.set("n", "gT", wrap_saga("Lspsaga finder"), { desc = "LSP Finder" })
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
vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

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
