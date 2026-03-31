


return {
  {
    "folke/flash.nvim",
    lazy = false,
    opts = {
      modes = {
        -- This is the only line that actually kills the original hook
        char = { enabled = true },
      },
    },
    -- Remove the manual config function entirely. 
    -- LazyVim's default handler is more efficient for simple opts.
  },
}


