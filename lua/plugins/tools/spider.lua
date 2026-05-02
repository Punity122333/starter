return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  keys = {
    -- 1. Movements (Normal & Visual)
    { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "x" }, desc = "Spider-w" },
    { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "x" }, desc = "Spider-e" },
    { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "x" }, desc = "Spider-b" },

    -- 2. Surgical Triple-Key Maps (Next sub-word)
    { "dpw", "d<cmd>lua require('spider').motion('w')<cr>", mode = "n", desc = "Delete sub-word (w)" },
    { "cpw", "c<cmd>lua require('spider').motion('w')<cr>", mode = "n", desc = "Change sub-word (w)" },
    { "ypw", "y<cmd>lua require('spider').motion('w')<cr>", mode = "n", desc = "Yank sub-word (w)" },
    { "vpw", "v<cmd>lua require('spider').motion('w')<cr>", mode = "n", desc = "Select sub-word (w)" },

    -- 3. Surgical Triple-Key Maps (End of sub-word)
    { "dpe", "d<cmd>lua require('spider').motion('e')<cr>", mode = "n", desc = "Delete to sub-word end" },
    { "cpe", "c<cmd>lua require('spider').motion('e')<cr>", mode = "n", desc = "Change to sub-word end" },
    { "ype", "y<cmd>lua require('spider').motion('e')<cr>", mode = "n", desc = "Yank to sub-word end" },
    { "vpe", "v<cmd>lua require('spider').motion('e')<cr>", mode = "n", desc = "Select to sub-word end" },

    -- 4. Surgical Triple-Key Maps (Back sub-word)
    { "dpb", "d<cmd>lua require('spider').motion('b')<cr>", mode = "n", desc = "Delete back sub-word" },
    { "cpb", "c<cmd>lua require('spider').motion('b')<cr>", mode = "n", desc = "Change back sub-word" },
    { "ypb", "y<cmd>lua require('spider').motion('b')<cr>", mode = "n", desc = "Yank back sub-word" },
    { "vpb", "v<cmd>lua require('spider').motion('b')<cr>", mode = "n", desc = "Select back sub-word" },
  },
}
