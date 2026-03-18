-- Fixes the "is not in runtimepath" error from checkhealth
-- Expanding the path ensures Neovim finds the parser queries (.scm files)
vim.opt.rtp:prepend(vim.fn.expand("~/.local/share/nvim/site"))

return {
  -- The injection handler: specialized for /* lang */ comments in strings
  {
    "TheNoeTrevino/roids.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("roids").setup({
        -- Detects these languages inside template strings
        languages = { "css", "html", "sql", "javascript", "typescript" },
      })
    end,
  },

  -- The main Treesitter engine
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    -- Lazy handles passing these opts to the plugin's internal setup
    opts = {
      ensure_installed = { 
        "c", "cpp", "lua", "vim", "vimdoc", "query",
        "typescript", "tsx", "javascript", "css", "html",
        "glsl", "hlsl", "wgsl" 
      },
      sync_install = false,
      auto_install = true,
      highlight = { 
        enable = true,
        -- Set to false so TS takes full control over the colors
        additional_vim_regex_highlighting = false,
        -- Keep your performance logic for large files
        disable = function(lang, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > 100 * 1024 then
            return true
          end
          if vim.wo.diff then
            return true
          end
          local disabled_filetypes = {
            "help", "dashboard", "avante", "avante-input", "gitcommit", "markdown", "oil", "TelescopePrompt", "alpha", "NvimTree"
          }
          local ft = vim.bo[buf].filetype
          for _, dft in ipairs(disabled_filetypes) do
            if ft == dft then return true end
          end
          
          if (lang == "c" or lang == "cpp") and vim.api.nvim_buf_line_count(buf) > 1000 then
            return true
          end
          return false
        end,
      },
      indent = { enable = true },
    },
  },
}
