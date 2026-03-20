return {
  "mrcjkb/rustaceanvim",
  version = "^8",
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        capabilities = (function()
          local caps = vim.lsp.protocol.make_client_capabilities()
          return caps
        end)(),
        settings = {
          ["rust-analyzer"] = {
            files = {
              excludeDirs = { ".git", "node_modules", "target" },
            },
            cargo = {
              buildScripts = { enable = false },
            },
            procMacro = {
              enable = false,
            },
            checkOnSave = false,
          },
        },
      },
    }
  end,
}
