-- Autosave configuration - saves file 1 second after you stop typing
return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" }, -- Save immediately on these events
        defer_save = { "InsertLeave", "TextChanged" }, -- Debounced save on these events
        cancel_deferred_save = { "InsertEnter" }, -- Cancel pending save when entering insert mode
      },
      debounce_delay = 1000, -- 1 second (1000ms) delay after you stop typing
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        
        -- Don't autosave for these conditions:
        if fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {
            "gitcommit",
            "gitrebase",
            "hgcommit",
            "oil",
          })
        then
          return true -- Enable autosave
        end
        return false -- Disable autosave
      end,
      write_all_buffers = false, -- Only save current buffer
      noautocmd = false, -- Trigger autocmds when saving (for formatters, linters, etc.)
    },
  },
}
