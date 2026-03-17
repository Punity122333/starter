return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- v2 is pretty old for 2026, ^5 is the move
    ft = { "rust" },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                capabilities = (function()
                    local caps = vim.lsp.protocol.make_client_capabilities()
                    caps.offsetEncoding = { "utf-8" }
                    return caps
                end)(),
                -- your other settings here
            },
        }
    end,
}
