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

				on_attach = function(_, bufnr)
					local DELAY_MS = 2500
					local timer = vim.uv.new_timer()

					vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
						buffer = bufnr,
						desc = "rust-analyzer: debounced flyCheck",
						callback = function()
							timer:stop()
							timer:start(DELAY_MS, 0, vim.schedule_wrap(function()
								vim.cmd.RustLsp({ "flyCheck", "run" })
								if ok_snacks and snacks.explorer
									and type(snacks.explorer.refresh) == "function"
								then
                  snacks.explorer.refresh()
								end
							end))
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
							-- Experimental diagnostics (type mismatch hints etc.)
							-- are expensive; disable unless you actively use them.
							experimental = { enable = false },
						},
						completion = {
							-- Full function signature completion requires RA to
							-- resolve the full type of every candidate — skip it.
							fullFunctionSignatures = { enable = false },
						},
					},
				},
			},
		}
	end,
}


