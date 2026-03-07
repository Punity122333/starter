return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "cpp", "glsl", "hlsl", "wgsl", "lua", "vim" },
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024
        end,
      },
      indent = { enable = false },
      incremental_selection = { enable = false },
    },
  },
}