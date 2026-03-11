local DashboardSections = {
  { section = "header" },
  { section = "keys", gap = 1, padding = 1 },
  { section = "startup" },
}
local DashboardHeader = [[
██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  
██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  
╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
 ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
      ██████╗ ██╗  ██╗███╗   ██╗██╗████████╗██╗   ██╗         
      ██╔══██╗╚██╗██╔╝████╗  ██║██║╚══██╔══╝╚██╗ ██╔╝         
      ██████╔╝ ╚███╔╝ ██╔██╗ ██║██║   ██║    ╚████╔╝          
      ██╔═══╝  ██╔██╗ ██║╚██╗██║██║   ██║     ╚██╔╝            
      ██║     ██╔╝ ██╗██║ ╚████║██║   ██║      ██║     ██╗    
      ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝      ╚═╝     ╚═╝     ]]

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = true,
      sections = DashboardSections,
      preset = {
        header = DashboardHeader,
      },
    },
  },
  specs = {
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#7aa2f7", bold = true })
      end,
    }
  }
}