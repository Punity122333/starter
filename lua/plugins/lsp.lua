-- LSP configurations - Direct attachment approach
return {
  {
    "neovim/nvim-lspconfig",
    cond = function()
      return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
    end,
    event = { "BufReadPre", "BufNewFile" },
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
        -- BasedPyright for Python
        basedpyright = {
          mason = false,
          cmd = { "/home/pxnity/.local/bin/basedpyright-langserver", "--stdio" },
          filetypes = { "python" },
          single_file_support = true,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("requirements.txt", "pyproject.toml", ".git")(fname) or vim.fn.getcwd()
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                reportMissingTypeStubs = false,
                reportUnknownMemberAccess = false,
                reportUnknownVariableType = false,
                reportUnknownArgumentType = false,
                reportUnannotatedClassAttribute = false,
              },
            },
          },
        },

        asm_lsp = {
          cmd = { "asm-lsp" },
          filetypes = { "asm", "s", "S", "nasm" },
          root_dir = function(fname)
            return vim.fn.getcwd()
          end,
          settings = {
            ["asm-lsp"] = {
              assembler = "nasm",
              instruction_set = "x86",
              default_diagnostics = false, -- Disable built-in diagnostics (they're usually wrong)
            },
          },
          -- Keep autocomplete/hover but disable the broken diagnostics
          on_attach = function(client, bufnr)
            -- Disable diagnostics but keep completion and hover
            client.server_capabilities.diagnosticProvider = false
            -- Disable diagnostics for this buffer (correct API for newer Neovim)
            vim.diagnostic.enable(false, { bufnr = bufnr })
          end,
        },

        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },

          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--query-driver=/usr/bin/g++,/usr/bin/gcc",
            "--fallback-style=google",
            "--pch-storage=memory",
            "-j=4",
          },
          single_file_support = true,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- Use the new vim.fs API for the git check to stop the deprecation warning
            local git_root = vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])

            return util.root_pattern("compile_commands.json", "compile_flags.txt")(fname) or git_root or vim.fn.getcwd()
          end,
          oot_dir = function(fname)
            return vim.fn.getcwd()
          end,
          on_attach = function(client, bufnr)
            if vim.api.nvim_buf_line_count(bufnr) > 2000 then
              client.server_capabilities.semanticTokensProvider = nil
            end
          end,
        },
        -- OmniSharp for C#
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

            -- If no project file found, create a minimal .csproj in the same directory
            if not root then
              local dir = vim.fn.fnamemodify(fname, ":h")
              -- Get the directory name (e.g., "Test" from "/path/to/Test")
              local dir_name = vim.fn.fnamemodify(dir, ":t")
              local csproj_path = dir .. "/" .. dir_name .. ".csproj"

              -- Check if csproj already exists
              if vim.fn.filereadable(csproj_path) == 0 then
                -- Create minimal .csproj for standalone files
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
          handlers = {
            ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
            ["textDocument/completion"] = vim.lsp.with(vim.lsp.handlers["textDocument/completion"], {
              -- Disable borders and extra UI for faster response
              border = "none",
            }),
          },
          on_attach = function(client, bufnr)
            -- Disable semantic tokens to fix syntax highlighting issues
            client.server_capabilities.semanticTokensProvider = nil

            -- Optimize completion settings
            if client.server_capabilities.completionProvider then
              client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
              client.server_capabilities.completionProvider.resolveProvider = true
            end

            -- Disable document symbol provider for faster performance
            client.server_capabilities.documentSymbolProvider = false
          end,
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = false, -- Faster without EditorConfig
              OrganizeImports = false, -- Disable for speed
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = false, -- Disable analyzers for faster completion
              EnableImportCompletion = true,
              AnalyzeOpenDocumentsOnly = true, -- Only analyze current file
              EnableDecompilationSupport = false,
            },
            Sdk = {
              IncludePrereleases = false,
            },
            -- Faster response
            msbuild = {
              loadProjectsOnDemand = true,
            },
          },
        },
        -- TypeScript/JavaScript
        ts_ls = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          single_file_support = true,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            local root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname)
            return root or vim.fn.getcwd()
          end,
        },
        -- HTML Language Server
        html = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html", "htm", "htmldjango" },
          single_file_support = true,
          root_dir = function(fname)
            return vim.fn.getcwd()
          end,
          on_attach = function(client, bufnr)
            client.server_capabilities.codeActionProvider = false
          end,
        },
        -- CSS Language Server
        cssls = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          single_file_support = true,
          root_dir = function(fname)
            return vim.fn.getcwd()
          end,
        },
        -- ESLint
        eslint = {
          cmd = { "vscode-eslint-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- Only attach if we can find an ESLint config file
            local root = util.root_pattern(
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json"
            )(fname)
            -- Also check for eslint in package.json
            if not root then
              local package_root = util.root_pattern("package.json")(fname)
              if package_root then
                local package_json = package_root .. "/package.json"
                local file = io.open(package_json, "r")
                if file then
                  local content = file:read("*a")
                  file:close()
                  -- Only use this root if package.json mentions eslint
                  if content:match('"eslint"') then
                    root = package_root
                  end
                end
              end
            end
            return root
          end,
          single_file_support = false, -- Don't attach to single files without config
          settings = {
            validate = "on",
            packageManager = "npm",
            useESLintClass = false,
            experimental = {
              useFlatConfig = false,
            },
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
            },
            format = false,
            quiet = false,
            onIgnoredFiles = "off",
            rulesCustomizations = {},
            run = "onType",
            problems = {
              shortenToSingleLine = false,
            },
            nodePath = "",
            workingDirectory = {
              mode = "auto",
            },
          },
          on_attach = function(client, bufnr)
            client.server_capabilities.codeActionProvider = false
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
        lua_ls = {
          filetypes = { "lua" },
          single_file_support = true,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                pathStrict = true, -- Only search for files in the runtime path
              },
              diagnostics = {
                enable = true, -- Keeping it on but making it smart
                globals = { "vim" },
                disable = { "lowercase-global", "undefined-global" }, -- Nuke the annoying ones
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                unusedLocalExclude = { "_*" }, -- Don't yell about variables starting with underscore
              },
              workspace = {
                -- This is the big one: Only load what you actually need
                library = {
                  vim.fn.expand("$VIMRUNTIME/lua"),
                  vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                  "${3rd}/luv/library", -- Just the essentials
                },
                checkThirdParty = false,
                maxPreload = 500, -- Half your original; stay lean
                preloadFileSize = 100, -- Smaller limit for faster startup
              },
              completion = {
                callSnippet = "Replace",
                displayContext = 1, -- Only show enough context to be useful
                postfix = "@", -- Better postfix trigger
              },
              hint = { enable = false }, -- Inlay hints are visual clutter for this vibe
              telemetry = { enable = false },
            },
          },
        },
        glsl_analyzer = {
          cmd = { "glsl_analyzer" },
          filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
          single_file_support = true,
          root_dir = function(fname)
            return vim.fn.getcwd()
          end,
          capabilities = {
            textDocument = {
              publishDiagnostics = {
                relatedInformation = true,
                tagSupport = { valueSet = { 1, 2 } },
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Force enable diagnostics for GLSL files
            vim.diagnostic.enable(true, { bufnr = bufnr })
          end,
        },
        -- glslls (commented out - uncomment if you have it installed via Mason)
        -- glslls = {
        --   cmd = { "glslls", "--stdin" },
        --   filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
        --   single_file_support = true,
        --   root_dir = function(fname)
        --     return vim.fn.getcwd()
        --   end,
        -- },
      },
    },
    config = function(_, opts)
      local diagnostic_timers = {}

      local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        local bufnr = vim.uri_to_bufnr(result.uri)

        if vim.api.nvim_get_mode().mode == "i" then
          if diagnostic_timers[bufnr] then
            vim.fn.timer_stop(diagnostic_timers[bufnr])
          end

          diagnostic_timers[bufnr] = vim.fn.timer_start(500, function()
            vim.schedule(function()
              original_handler(err, result, ctx, config)
              diagnostic_timers[bufnr] = nil
            end)
          end)
        else
          original_handler(err, result, ctx, config)
        end
      end

      vim.api.nvim_create_autocmd("InsertLeave", {
        group = vim.api.nvim_create_augroup("DiagnosticsInsertLeave", { clear = true }),
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          if diagnostic_timers[bufnr] then
            vim.fn.timer_stop(diagnostic_timers[bufnr])
            diagnostic_timers[bufnr] = nil
          end
          vim.diagnostic.show(nil, bufnr)
        end,
      })

      vim.diagnostic.config(opts.diagnostics)

      -- Get lspconfig
      local ok, lspconfig = pcall(require, "lspconfig")
      if not ok then
        vim.notify("Failed to load lspconfig", vim.log.levels.ERROR)
        return
      end

      -- Get default capabilities - try Blink first, then cmp, then fallback
      local default_capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Try Blink.cmp first (LazyVim's new default)
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        default_capabilities = blink.get_lsp_capabilities(default_capabilities)
      else
        -- Fallback to nvim-cmp
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
        end
      end

      -- Ensure completion is explicitly enabled
      default_capabilities.textDocument.completion.completionItem.snippetSupport = true
      default_capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      }

      for server_name, server_config in pairs(opts.servers) do
        -- Skip non-LSP entries that might come from LazyVim or other plugins
        local skip_servers = {
          "copilot",
          "stylua",
          "*",
          "tsserver",
          "ruff",
          "ruff_lsp",
        }

        local should_skip = false
        for _, skip_name in ipairs(skip_servers) do
          if server_name == skip_name then
            should_skip = true
            break
          end
        end

        if should_skip then
          goto continue
        end

        -- Create a new config table to avoid modifying the original
        local config = vim.deepcopy(server_config)

        -- Merge with default capabilities
        config.capabilities = vim.tbl_deep_extend("force", {}, default_capabilities, config.capabilities or {})
        -- Check if the server exists in lspconfig before setup
        if lspconfig[server_name] then
          local setup_ok, setup_err = pcall(function()
            lspconfig[server_name].setup(config)
          end)

          if not setup_ok then
            vim.notify("Failed to setup '" .. server_name .. "': " .. tostring(setup_err), vim.log.levels.WARN)
          end
        end

        ::continue::
      end
    end,
  },
  {
    "3rd/image.nvim",
    cond = function()
      return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = function()
      return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
    end,
  },
}
