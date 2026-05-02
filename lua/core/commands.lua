vim.api.nvim_create_user_command("RefreshAll", "bufdo edit!", { desc = "Reload all buffers from disk" })

vim.api.nvim_create_user_command("Format", function(args)
    require("conform").format({
        async = true,
        lsp_fallback = true,
        range = args.count ~= -1 and { start = { args.line1, 0 }, ["end"] = { args.line2, 0 } } or nil,
    })
end, { range = true })
