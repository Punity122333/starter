
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			if before_cursor:match("{%s*$") then
				vim.snippet.expand("\n\t$0\n")
				return
			end

			local lua_keywords = { "then", "do", "function" }
			local special_word = { "repeat" }

			for _, kw in ipairs(lua_keywords) do
				if before_cursor:match(kw .. "%s*$") then
					vim.snippet.expand("\n\t$0\nend")
					return
				end
			end

			for _, kw in ipairs(special_word) do
				if before_cursor:match(kw .. "%s*$") then
					vim.snippet.expand("\n\t$0\nuntil")
					return
				end
			end

			-- fallback
			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "bash", "zsh" },
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			if before_cursor:match("{%s*$") then
				vim.snippet.expand("\n\t$0\n}")
				return
			end

			local fi_keywords = { "then" }
			for _, kw in ipairs(fi_keywords) do
				if before_cursor:match(kw .. "%s*$") then
					vim.snippet.expand("\n\t$0\nfi")
					return
				end
			end

			local done_keywords = { "do" }
			for _, kw in ipairs(done_keywords) do
				if before_cursor:match(kw .. "%s*$") then
					vim.snippet.expand("\n\t$0\ndone")
					return
				end
			end

			if before_cursor:match("in%s*$") then
				vim.snippet.expand("\n\t$0\nesac")
				return
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "vim",
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			local block_keywords = {
				"if",
				"for",
				"while",
				"function",
				"augroup",
				"try",
				"lua",
			}

			for _, kw in ipairs(block_keywords) do
				if before_cursor:match(kw .. "%s*$") then
					local close_map = {
						if_ = "endif",
						for_ = "endfor",
						while_ = "endwhile",
						function_ = "endfunction",
						augroup_ = "augroup END",
						try_ = "endtry",
						lua_ = "end",
					}

					local key = kw .. "_"
					local closing = close_map[key]

					if closing then
						vim.snippet.expand("\n\t$0\n" .. closing)
						return
					end
				end
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cobol" },
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			local map = {
				["then%s*$"] = "END-IF",
				["perform%s*$"] = "END-PERFORM",
				["evaluate%s*$"] = "END-EVALUATE",
			}

			for pat, close in pairs(map) do
				if before_cursor:match(pat) then
					vim.snippet.expand("\n\t$0\n" .. close)
					return
				end
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fortran" },
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			if before_cursor:match("then%s*$") then
				vim.snippet.expand("\n\t$0\nend if")
				return
			end

			if before_cursor:match("do%s*$") then
				vim.snippet.expand("\n\t$0\nend do")
				return
			end

			if before_cursor:match("where%s*$") then
				vim.snippet.expand("\n\t$0\nend where")
				return
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "pascal", "ada" },
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			if before_cursor:match("begin%s*$") then
				vim.snippet.expand("\n\t$0\nend")
				return
			end

			if before_cursor:match("then%s*$") then
				vim.snippet.expand("\n\t$0\nend if")
				return
			end

			local loop_keywords = { "loop" }
			for _, kw in ipairs(loop_keywords) do
				if before_cursor:match(kw .. "%s*$") then
					vim.snippet.expand("\n\t$0\nend loop")
					return
				end
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "plsql", "postgres" },
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			if before_cursor:match("begin%s*$") then
				vim.snippet.expand("\n\t$0\nend")
				return
			end

			if before_cursor:match("then%s*$") then
				vim.snippet.expand("\n\t$0\nend if")
				return
			end

			if before_cursor:match("loop%s*$") then
				vim.snippet.expand("\n\t$0\nend loop")
				return
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { buffer = true, silent = true })
	end,
})
