
for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do 
  local fg = hl.fg and string.format("#%06x", hl.fg) 
  local bg = hl.bg and string.format("#%06x", hl.bg) 
  if fg == "#111116" or bg == "#111116" then 
    print(string.format("%s: fg=%s, bg=%s", name, fg or "none", bg or "none")) 
  end 
end
