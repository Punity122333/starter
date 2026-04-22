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
				on_attach = function(client, bufnr)
					local timer = nil
					local DELAY_MS = 1500

					vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
						buffer = bufnr,
						desc = "rust-analyzer: debounced flyCheck",
						callback = function()
							if timer then
								timer:stop()
								timer:close()
							end
							timer = vim.defer_fn(function()
								timer = nil
								vim.cmd.RustLsp({ "flyCheck", "run" })
								require("lualine").refresh({ place = { "statusline" } })
								pcall(function()
									local snacks = require("snacks")
									if snacks.explorer and type(snacks.explorer.refresh) == "function" then
										snacks.explorer.refresh()
									end
								end)
							end, DELAY_MS)
						end,
					})
				end,
				settings = {
					["rust-analyzer"] = {
						files = {
							excludeDirs = { ".git", "node_modules", "target" },
						},
						cargo = {
							buildScripts = { enable = false },
						},
						procMacro = {
							enable = true,
						},
						checkOnSave = false,
					},
				},
			},
		}
	end,
}

