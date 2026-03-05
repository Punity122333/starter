return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Use lazy loading to defer until the buffer is actually readable
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "cpp", "glsl", "hlsl", "wgsl", "lua", "vim" },
      sync_install = false, -- Never block startup
      highlight = {
        enable = true,
        -- CRITICAL: This stops the C-call boundary errors and improves speed
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024 -- 100 KB limit
        end,
      },
      indent = { enable = false }, -- Indent via Treesitter is often a bottleneck
      incremental_selection = { enable = false },
    },
  },
}