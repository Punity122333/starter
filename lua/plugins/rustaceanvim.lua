return {
	"mrcjkb/rustaceanvim",
	version = "^8",
	ft = { "rust" },
	config = function()
		local ok_snacks, snacks = pcall(require, "snacks")

		vim.g.rustaceanvim = {
			server = {
				capabilities = (function()
					local caps = vim.lsp.protocol.make_client_capabilities()
					local ok_blink, blink = pcall(require, "blink.cmp")
					if ok_blink then
						caps = blink.get_lsp_capabilities(caps)
					end
					return caps
				end)(),

				on_attach = function(client, bufnr)
					local DELAY_MS = 2500
					local timer = vim.uv.new_timer()

					client.server_capabilities.semanticTokensProvider = nil
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = bufnr,
						desc = "rust-analyzer: debounced flyCheck on cursor idle",
						callback = function()
							timer:stop()
							timer:start(
								DELAY_MS,
								0,
								vim.schedule_wrap(function()
									vim.cmd.RustLsp({ "flyCheck", "run" })
									if
										ok_snacks
										and snacks.explorer
										and type(snacks.explorer.refresh) == "function"
									then
										snacks.explorer.refresh()
									end
								end)
							)
						end,
					})

					vim.api.nvim_buf_attach(bufnr, false, {
						on_detach = function()
							if not timer:is_closing() then
								timer:stop()
								timer:close()
							end
						end,
					})
				end,

				settings = {
					["rust-analyzer"] = {
						numThreads = 4, 
						cachePriming = {
              enable = true,
							numThreads = 2,
						},
						files = {
							excludeDirs = { ".git", "node_modules", "target" },
						},
						cargo = {
							buildScripts = { enable = false },
							allTargets = false,
						},
						procMacro = {
							enable = true,
						},
						checkOnSave = false,
						diagnostics = {
							experimental = { enable = false },
						},
						completion = {
							fullFunctionSignatures = { enable = false },
						},
					},
				},
			},
		}
	end,
}
