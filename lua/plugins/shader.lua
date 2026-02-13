-- Shader language support configuration
return {
  -- Add shader file type detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Ensure shader file types are recognized
      vim.filetype.add({
        extension = {
          glsl = "glsl",
          vert = "glsl",
          frag = "glsl",
          tesc = "glsl",
          tese = "glsl",
          geom = "glsl",
          comp = "glsl",
          hlsl = "hlsl",
          hlsli = "hlsl",
          fx = "hlsl",
          fxh = "hlsl",
          vsh = "hlsl",
          psh = "hlsl",
          wgsl = "wgsl",
        },
        filename = {
          ["*.vert"] = "glsl",
          ["*.frag"] = "glsl",
          ["*.tesc"] = "glsl",
          ["*.tese"] = "glsl",
          ["*.geom"] = "glsl",
          ["*.comp"] = "glsl",
          ["*.vs"] = "hlsl",
          ["*.ps"] = "hlsl",
          ["*.gs"] = "hlsl",
          ["*.cs"] = "hlsl",
        },
      })
    end,
  },
  
  -- Add GLSL LSP server (glsl_analyzer) + glslangValidator linter
  -- Note: glsl_analyzer provides LSP features (completion, hover, etc.)
  --       glslangValidator provides comprehensive shader validation (via nvim-lint)
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- glsl_analyzer - GLSL language server (must be built from source)
        glsl_analyzer = {
          cmd = { "glsl_analyzer" },
          filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
          single_file_support = true,
          root_dir = function(fname)
            return vim.fn.getcwd()
          end,
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true
                }
              },
              publishDiagnostics = {
                relatedInformation = true,
                tagSupport = { valueSet = { 1, 2 } },
              },
            }
          },
        },
        -- glslls - Alternative (commented out, uncomment if installed via :MasonInstall glslls)
        -- glslls = {
        --   cmd = { "glslls", "--stdin" },
        --   filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
        --   single_file_support = true,
        --   root_dir = function(fname)
        --     return vim.fn.getcwd()
        --   end,
        --   capabilities = {
        --     textDocument = {
        --       completion = {
        --         completionItem = {
        --           snippetSupport = true
        --         }
        --       }
        --     }
        --   },
        -- },
      },
    },
  },
}
