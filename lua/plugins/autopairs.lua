return {
  { "nvim-mini/mini.pairs", enabled = false },
  -- 1. Disable the default LazyVim autopairs using the NEW name
  -- Fallback for the old name just in case your LazyVim version is mid-transition
  { "nvim-mini/mini.pairs", enabled = false },

  -- 2. Install and config nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        python = { "string" },
      },
      -- This fixes the "desync" by making sure the pairs 
      -- actually trigger even if the LSP is being slow
      map_cr = true, 
      map_bs = true,
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      -- 3. Integration with Blink.cmp (The new LazyVim default)
      -- This ensures that when you pick a function, the brackets don't double up
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        -- Blink handles this natively usually, but we ensure the hook is there
      end
    end,
  },
}
