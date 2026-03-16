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

        basedpyright = {
          mason = false,
          cmd = { "/home/pxnity/.local/bin/basedpyright-langserver", "--stdio" },
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
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

          handlers = {

            ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],

            ["textDocument/completion"] = vim.lsp.with(vim.lsp.handlers["textDocument/completion"], {

              border = "rounded",
            }),
          },
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

        ts_ls = {

          cmd = { "typescript-language-server", "--stdio" },

          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },

          single_file_support = true,

          root_dir = function(fname)
            local util = require("lspconfig.util")

            return util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname) or vim.fn.getcwd()
          end,
        },

        lua_ls = {
          cmd = { "/home/pxnity/.local/share/nvim/mason/bin/lua-language-server" },
          on_attach = function(client, bufnr)
            -- Kill all diagnostics for this client
            client.server_capabilities.diagnosticProvider = false
            vim.diagnostic.enable(false, { bufnr = bufnr })

            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentSymbolProvider = false
          end,
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              -- FORCE DIAGONISTICS TO BE LAZY
              diagnostics = {
                globals = { "vim" },
                disable = { "lowercase-global", "undefined-global", "missing-fields" },
                -- THIS STOPS THE "DIAGNOSING" LOOP
                neededFileStatus = {
                  ["codestyle-check"] = "None",
                  ["unused-local"] = "None",
                },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath("config") .. "/lua",
                },
                ignoreDir = { "**/node_modules", "**/lazy" },
                preloadFileSize = 0,
                -- ADD THIS TO PREVENT WORKSPACE RE-SCANNING
                libraryStatus = "None",
              },
              telemetry = { enable = false },
            },
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
      },
    },

    config = function(_, opts)
      vim.diagnostic.config(opts.diagnostics)

      -- local timer = vim.loop.new_timer()

      vim.api.nvim_create_autocmd("LspAttach", {

        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end
        end,
      })

      local ok, lspconfig = pcall(require, "lspconfig")

      if not ok then
        return
      end

      local default_capabilities = vim.lsp.protocol.make_client_capabilities()

      if

        default_capabilities.textDocument
        and default_capabilities.textDocument.completion
        and default_capabilities.textDocument.completion.completionItem
      then
        default_capabilities.textDocument.completion.completionItem.snippetSupport = true
      end

      local has_blink, blink = pcall(require, "blink.cmp")

      if has_blink then
        default_capabilities = blink.get_lsp_capabilities(default_capabilities)
      else
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

        if has_cmp then
          default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
        end
      end

      for server_name, server_config in pairs(opts.servers) do
        local skip_servers =
          { "copilot", "stylua", "*", "tsserver", "ruff", "ruff_lsp", "rust_analyzer", "r_language_server" }

        local should_skip = false

        for _, skip_name in ipairs(skip_servers) do
          if server_name == skip_name then
            should_skip = true

            break
          end
        end

        if not should_skip and lspconfig[server_name] then
          local config = vim.deepcopy(server_config)

          config.capabilities = vim.tbl_deep_extend("force", {}, default_capabilities, config.capabilities or {})

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

  {

    "nvim-lualine/lualine.nvim",

    cond = function()
      return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
    end,
  },
}
