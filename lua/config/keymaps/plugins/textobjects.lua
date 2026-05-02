local function map2(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end
local modes = { "n", "o", "x" }

map2(modes, "gkiw", "<cmd>lua require('various-textobjs').subword('inner')<CR>", "Inner Subword")
map2(modes, "gkaw", "<cmd>lua require('various-textobjs').subword('outer')<CR>", "Outer Subword")
map2(modes, "gkim", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", "Inner Chain Member")
map2(modes, "gkam", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", "Outer Chain Member")
map2(modes, "gkic", "<cmd>lua require('various-textobjs').column('inner')<CR>", "Inner Column")
map2(modes, "gkac", "<cmd>lua require('various-textobjs').column('outer')<CR>", "Outer Column")
map2(modes, "gkii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", "Inner Indent")
map2(modes, "gkai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", "Outer Indent")
map2(modes, "gkig", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", "Entire Buffer")
map2(modes, "gkin", "<cmd>lua require('various-textobjs').nearLine('inner')<CR>", "Near Line")
map2(modes, "gkiu", "<cmd>lua require('various-textobjs').url()<CR>", "URL")
map2(modes, "gkid", "<cmd>lua require('various-textobjs').diagnostic()<CR>", "Diagnostic")
map2(modes, "gkik", "<cmd>lua require('various-textobjs').key('inner')<CR>", "Key")

pcall(function()
    require("which-key").add({
        { "gk",  group = "various-textobjs" },
        { "gki", group = "inner" },
        { "gka", group = "around" },
    })
end)
