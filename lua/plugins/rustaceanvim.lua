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
			},
		}
	end,
}
