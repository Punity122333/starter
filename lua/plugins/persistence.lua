return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      -- Directory where session files are saved
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      -- Options to save in the session
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
      -- Auto-save session when exiting
      pre_save = nil,
      -- Auto-load last session when opening nvim without arguments
      save_empty = false,
    },
    -- Setup keymaps for manual session control
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      
      -- Auto-restore session when opening nvim in a directory without file arguments
      local function restore_session()
        -- Only restore if:
        -- 1. We're in a real directory (not home or root)
        -- 2. No files were specified on command line
        -- 3. It's not a special buffer type
        if vim.fn.argc() == 0 then
          local cwd = vim.fn.getcwd()
          local home = vim.fn.expand("~")
          
          -- Don't restore in home directory or root
          if cwd ~= home and cwd ~= "/" then
            require("persistence").load()
          end
        end
      end
      
      -- Auto-restore after VimEnter
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
        callback = function()
          -- Defer to let other plugins load first
          vim.defer_fn(restore_session, 100)
        end,
        nested = true,
      })
    end,
  },
}
