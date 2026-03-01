return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      dim_inactive = false,
      styles = {
        sidebars = "normal",
        floats = "normal",
      },
      on_highlights = function(hl, c)
        local night_bg = "#1a1b26"
        local light_blue = "#82aaff"
        hl["@variable"] = { fg = light_blue }
        hl["@variable.builtin"] = { fg = light_blue }
        hl["@variable.parameter"] = { fg = light_blue }
        hl["@variable.member"] = { fg = light_blue }
        hl["@property"] = { fg = light_blue }
        hl["@field"] = { fg = light_blue }
        hl["@identifier"] = { fg = light_blue }
        hl["@lsp.type.variable"] = { fg = light_blue }
        hl["@lsp.type.parameter"] = { fg = light_blue }
        hl["@lsp.type.property"] = { fg = light_blue }
        local solid_bg = { bg = night_bg, blend = 0 }
        hl.Normal = solid_bg
        hl.NormalNC = solid_bg
        hl.NormalSB = solid_bg
        hl.NormalFloat = solid_bg
        hl.FloatBorder = { bg = night_bg, fg = c.border_highlight, blend = 0 }
        hl.FloatTitle = { bg = night_bg, fg = light_blue, blend = 0 }
        hl.SnacksBackdrop = { bg = night_bg, blend = 0 }
        hl.TelescopeBackdrop = { bg = night_bg, blend = 0 }
        hl.TelescopeNormal = solid_bg
        hl.TelescopeBorder = { bg = night_bg, fg = c.border_highlight, blend = 0 }
        hl.TelescopePromptNormal = solid_bg
        hl.TelescopePromptBorder = { bg = night_bg, fg = c.border_highlight, blend = 0 }
        hl.TelescopeResultsNormal = solid_bg
        hl.TelescopePreviewNormal = solid_bg
        hl.FloatShadow = { bg = "none", blend = 0 }
        hl.FloatShadowThrough = { bg = "none", blend = 0 }
        hl.BlinkCmpSignatureHelp = { bg = "#15151c", blend = 0 }
        hl.NoiceLspSignatureHelp = { bg = "#15151c", blend = 0 }
        hl.LspSignatureActiveParameter = { bg = "#15151c", blend = 0 }
        hl.NoicePopup = { bg = "#15151c", blend = 0 }
        hl.NoicePopupBorder = { bg = "#15151c", fg = "#232330", blend = 0 }
        hl.MsgArea = solid_bg
        hl.StatusLine = { bg = night_bg }
        hl.StatusLineNC = { bg = night_bg }
        hl.BufferLineFill = { bg = night_bg }
        hl.BufferLineBackground = { bg = night_bg }
        hl.BufferLineSeparator = { fg = night_bg, bg = night_bg }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      
      vim.opt.winblend = 0
      vim.opt.pumblend = 0
      vim.cmd("colorscheme tokyonight-night")
      vim.api.nvim_set_hl(0, "SnacksBackdrop", { bg = "#1a1b26", blend = 0 })
    end,
  },
}
