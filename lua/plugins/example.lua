return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, -- Lazy load on filetype
    opts = {
      -- Performance: Disable heavy features
      inlay_hints = {
        inline = false, -- Don't show inline hints (performance)
        only_current_line = false,
        show_parameter_hints = false,
        show_variable_name = false,
        parameter_hints_prefix = "",
        other_hints_prefix = "",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
      },
      -- AST features - disable for performance
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = {
          detail = "Comment",
        },
      },
      -- Memory indicator - lightweight
      memory_usage = {
        border = "rounded",
      },
      -- Symbol info - keep this, it's useful and not too heavy
      symbol_info = {
        border = "rounded",
      },
    },
  },
}
