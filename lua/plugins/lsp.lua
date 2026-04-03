return {
	{
		"neovim/nvim-lspconfig",
		cond = function()
			return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
		end,
		event = { "BufReadPost" },
		dependencies = {
			"mason.nvim",
		},
		opts = {
			diagnostics = {
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				virtual_text = {
					spacing = 4,
					prefix = "●",
				},
				float = {
					border = "rounded",
					source = "always",
				},
			},
			servers = {
				vtsls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyQuery = true,
								},
							},
						},
						typescript = {
							updateImportsOnPaste = true,
							suggest = {
								completeFunctionCalls = true,
							},
						},
					},
				},
				basedpyright = {
					mason = false,
					cmd = { "/home/pxnity/.local/bin/basedpyright-langserver", "--stdio" },
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "strict",
								diagnosticMode = "openFilesOnly",
								reportMissingTypeStubs = false,
								reportUnknownMemberAccess = false,
								reportUnknownVariableType = false,
								reportUnannotatedClassAttribute = false,
								autoImportCompletions = false,
								indexing = false,
							},
						},
					},
				},
				marksman = {
					filetypes = { "markdown", "markdown.mdx" },
					root_dir = function(fname)
						local util = require("lspconfig.util")
						return util.root_pattern(".git", ".marksman.toml", "README.md")(fname) or vim.fn.getcwd()
					end,
				},
				asm_lsp = {
					cmd = { "asm-lsp" },
					filetypes = { "asm", "s", "S", "nasm" },
					root_dir = function()
						return vim.fn.getcwd()
					end,
					settings = {
						["asm-lsp"] = {
							assembler = "nasm",
							instruction_set = "x86",
							default_diagnostics = false,
						},
					},
					on_attach = function(client, bufnr)
						client.server_capabilities.diagnosticProvider = false
						vim.diagnostic.enable(false, { bufnr = bufnr })
					end,
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--query-driver=/usr/bin/g++,/usr/bin/gcc",
						"--fallback-style=google",
						"--pch-storage=memory",
						"--limit-references=0",
						"-j=4",
					},
					on_attach = function(client, bufnr)
						if vim.api.nvim_buf_line_count(bufnr) > 2000 then
							client.server_capabilities.semanticTokensProvider = nil
						end
						client.server_capabilities.documentFormattingProvider = false
					end,
				},

				lua_ls = {
					on_attach = function(client, bufnr)
						client.server_capabilities.diagnosticProvider = false
						client.server_capabilities.semanticTokensProvider = nil
						client.server_capabilities.documentSymbolProvider = false
					end,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = {
								globals = { "vim" },
								updateOn = "OnSave",
								disable = { "lowercase-global", "undefined-global", "missing-fields" },
							},
							checkThirdParty = false,
							workspace = {
								checkThirdParty = false,
								library = { vim.fn.stdpath("config") .. "/lua" },
								ignoreDir = { "**/node_modules", "**/lazy", "**/.git", "**/packer_compiled.lua" },
								libraryStatus = "None",
							},
							telemetry = { enable = false },
						},
					},
				},
				omnisharp = {
					cmd = {
						"omnisharp",
						"--languageserver",
						"--hostPID",
						tostring(vim.fn.getpid()),
					},
					filetypes = { "cs", "vb" },
					single_file_support = true,
					root_dir = function(fname)
						local util = require("lspconfig.util")
						local root = util.root_pattern("*.sln", "*.csproj", "omnisharp.json")(fname)
						if not root then
							local dir = vim.fn.fnamemodify(fname, ":h")
							local dir_name = vim.fn.fnamemodify(dir, ":t")
							local csproj_path = dir .. "/" .. dir_name .. ".csproj"
							if vim.fn.filereadable(csproj_path) == 0 then
								local csproj_content = [[<Project Sdk="Microsoft.NET.Sdk">
                                            <PropertyGroup>
                                                <OutputType>Exe</OutputType>
                                                <TargetFramework>net8.0</TargetFramework>
                                                <ImplicitUsings>enable</ImplicitUsings>
                                                <Nullable>enable</Nullable>
                                            </PropertyGroup>
                                            </Project>]]
								local file = io.open(csproj_path, "w")
								if file then
									file:write(csproj_content)
									file:close()
								end
							end
							return dir
						end
						return root
					end,
					on_attach = function(client, bufnr)
						client.server_capabilities.semanticTokensProvider = nil
						if client.server_capabilities.completionProvider then
							client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
							client.server_capabilities.completionProvider.resolveProvider = true
						end
						client.server_capabilities.documentSymbolProvider = false
					end,
					settings = {
						FormattingOptions = {
							EnableEditorConfigSupport = false,
							OrganizeImports = false,
						},
						RoslynExtensionsOptions = {
							EnableAnalyzersSupport = false,
							EnableImportCompletion = true,
							AnalyzeOpenDocumentsOnly = true,
							EnableDecompilationSupport = false,
						},
						Sdk = { IncludePrereleases = false },
						msbuild = { loadProjectsOnDemand = true },
					},
				},
				glsl_analyzer = {
					cmd = { "glsl_analyzer" },
					filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
					root_dir = function(fname)
						return vim.fn.getcwd()
					end,
					on_attach = function(client, bufnr)
						vim.diagnostic.enable(true, { bufnr = bufnr })
					end,
				},
				cssls = {
					filetypes = {
						"css",
						"scss",
						"less",
						"typescript",
						"typescriptreact",
						"javascript",
						"javascriptreact",
					},
					settings = {
						css = { validate = true },
						scss = { validate = true },
					},
					init_options = {
						provideFormatter = true,
					},
				},
				html = {
					filetypes = { "html", "javascriptreact", "typescriptreact" },
					init_options = {
						configurationSection = { "html", "css", "javascript" },
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = true,
					},
				},
			},
		},
		config = function(_, opts)
			vim.diagnostic.config(opts.diagnostics) 
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok then
				return
			end

			local default_capabilities = vim.lsp.protocol.make_client_capabilities()
			default_capabilities.general = default_capabilities.general or {}
			default_capabilities.general.positionEncodings = { "utf-8" }

			local skip_servers = {
				copilot = true,
				stylua = true,
				tsserver = true,
				ts_ls = true,
				ruff = true,
				ruff_lsp = true,
				rust_analyzer = true,
				r_language_server = true,
				tsgo = true,
				oxfmt = true,
				["*"] = true,
			}

			for server_name, server_config in pairs(opts.servers) do
				if not skip_servers[server_name] and lspconfig[server_name] then
					local config = vim.deepcopy(server_config)
					config.capabilities =
						vim.tbl_deep_extend("force", {}, default_capabilities, config.capabilities or {})

					config.offsetEncoding = "utf-8"

					if
            
						config.capabilities.textDocument
						and config.capabilities.textDocument.completion
						and config.capabilities.textDocument.completion.completionItem
					then
						config.capabilities.textDocument.completion.completionItem.snippetSupport = true
					end

					lspconfig[server_name].setup(config)
				end
			end
		end,
	},
	{
		"3rd/image.nvim",
		cond = function()
			return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
		end,
	},
}
