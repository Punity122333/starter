return {
  "Punity122333/hexinspector.nvim",
  cmd = { "HexEdit", "HexInspect" },
  keys = {
    {
      "<leader>zx",
      function()
        require("hexinspector").open()
      end,
      desc = "Hex Editor",
    },
    {
      "<leader>zX",
      function()
        vim.ui.input({ prompt = "File path: ", default = vim.fn.expand("%:p") }, function(input)
          if input and input ~= "" then
            require("hexinspector").open(input)
          end
        end)
      end,
      desc = "Hex Editor (Pick File)",
    },
  },
  
}
