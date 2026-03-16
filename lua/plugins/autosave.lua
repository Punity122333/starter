local ImmediateSaveEvents = { "BufLeave", "FocusLost" }
local DeferSaveEvents = { "InsertLeave", "TextChanged" }
local CancelDeferredSaveEvents = { "InsertEnter" }
local DebounceDelay = 1000
local ExcludedFiletypes = {
  "gitcommit",
  "gitrebase",
  "hgcommit",
  "oil",
}

return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = ImmediateSaveEvents,
        defer_save = DeferSaveEvents,
        cancel_deferred_save = CancelDeferredSaveEvents,
      },
      debounce_delay = DebounceDelay,
      condition = function(buffer)
        if vim.snippet and vim.snippet.active({ direction = 1 }) then
          return false
        end

        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        if
          fn.getbufvar(buffer, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buffer, "&filetype"), ExcludedFiletypes)
        then
          return true
        end
        return false
      end,
      noautocmd = false,
    },
  },
}
