return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
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
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
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
                }
              },
              publishDiagnostics = {
                relatedInformation = true,
                tagSupport = { valueSet = { 1, 2 } },
              },
            }
          },
        },
      },
    },
  },
}
