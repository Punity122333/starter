
local target = "#1a1b26"
local bad = {}

for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
  if name:match("DapUI") then
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    local bg = hl.bg and string.format("#%06x", hl.bg) or "NONE"

    if bg:lower() ~= target then
      table.insert(bad, name .. " -> " .. bg)
    end
  end
end

print(vim.inspect(bad))
