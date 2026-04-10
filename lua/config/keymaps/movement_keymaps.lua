-- Movement Keymaps
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
--
-- local function read_until_cr()
-- 	local out = ""
-- 	while true do
-- 		local c = vim.fn.getcharstr()
-- 		if c == "\r" then
-- 			break
-- 		end
-- 		out = out .. c
-- 	end
-- 	return out
-- end
--
-- local function read_target()
-- 	local c1 = vim.fn.getcharstr()
--
-- 	if c1:match("%d") then
-- 		return c1 .. read_digits()
-- 	end
--
-- 	if c1 == "+" or c1 == "-" then
-- 		local c2 = vim.fn.getcharstr()
-- 		if c2:match("%d") then
-- 			return c1 .. c2 .. read_digits()
-- 		end
-- 		feed(c2)
-- 		return c1
-- 	end
--
-- 	if c1 == "'" then
-- 		local m = vim.fn.getcharstr()
-- 		return "'" .. m
-- 	end
--
-- 	if c1 == "/" or c1 == "?" then
-- 		local p = read_until_cr()
-- 		return c1 .. p
-- 	end
--
-- 	if c1 == "g" then
-- 		local c2 = vim.fn.getcharstr()
-- 		if c2 == "g" then
-- 			return "0"
-- 		end
-- 		feed(c2)
-- 		return nil
-- 	end
--
-- 	if c1 == "G" then
-- 		return "$"
-- 	end
--
-- 	if c1 == "." or c1 == "$" then
-- 	``	return c1
-- 	end
--
-- 	return nil
-- end

vim.keymap.set("n", "<leader>O", function()
	vim.cmd("Outline")
end, { desc = "Open Outline" })

vim.keymap.set("i", "<CR>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local before_cursor = line:sub(1, col)

	if before_cursor:match("{%s*$") then
		-- $0 is where your cursor lands
		vim.snippet.expand("\n\t$0\n")
		return
	end

	local lua_keywords = { "then", "do", "function" }
	for _, kw in ipairs(lua_keywords) do
		if before_cursor:match(kw .. "%s*$") then
			vim.snippet.expand("\n\t$0\nend")
			return
		end
	end

	-- Regular enter fallback
	local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
	vim.api.nvim_feedkeys(cr, "n", true)
end, { silent = true })

