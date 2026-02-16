return {
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy", -- Keep that 300ms boot speed snappy
    init = function()
      -- This is where you'd remap stuff if you want it to feel 1:1 like VS Code
      -- vim.g.VM_maps = { ["Find Under"] = "<C-d>" }
    end,
  },
}