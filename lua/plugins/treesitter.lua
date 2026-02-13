return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Ensure shader language parsers are installed
      ensure_installed = {
        "glsl",  -- OpenGL Shading Language
        "hlsl",  -- High-Level Shading Language (DirectX)
        "wgsl",  -- WebGPU Shading Language
      },
      -- Fix the "attempt to yield across C-call boundary" error
      -- by disabling the conceal feature that causes issues
      highlight = {
        enable = true,
        -- Disable treesitter for these cases to prevent the C-call error
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      -- Disable incremental selection to reduce errors
      incremental_selection = {
        enable = false,
      },
    },
  },
}
