local rules = {
	lua = {
		["{%s*$"] = "",
		["then%s*$"] = "end",
		["do%s*$"] = "end",
		["function%s*$"] = "end",
		["repeat%s*$"] = "until",
	},
	sh = {
		["{%s*$"] = "}",
		["then%s*$"] = "fi",
		["do%s*$"] = "done",
		["in%s*$"] = "esac",
	},
	["vim"] = { 
		["if%s*$"] = "endif",
		["for%s*$"] = "endfor",
		["while%s*$"] = "endwhile",
		["function%s*$"] = "endfunction",
		["augroup%s*$"] = "augroup END",
		["try%s*$"] = "endtry",
		["lua%s*$"] = "end",
	},
	cobol = {
		["then%s*$"] = "END-IF",
		["perform%s*$"] = "END-PERFORM",
		["evaluate%s*$"] = "END-EVALUATE",
	},
	fortran = {
		["then%s*$"] = "end if",
		["do%s*$"] = "end do",
		["where%s*$"] = "end where",
	},
	pascal = {
		["begin%s*$"] = "end",
		["then%s*$"] = "end if",
		["loop%s*$"] = "end loop",
	},
	sql = {
		["begin%s*$"] = "end",
		["then%s*$"] = "end if",
		["loop%s*$"] = "end loop",
	},
	ruby = {
		["if%s*$"] = "end",
		["unless%s*$"] = "end",
		["def%s*$"] = "end",
		["class%s*$"] = "end",
		["module%s*$"] = "end",
		["do%s*$"] = "end",
		["while%s*$"] = "end",
		["for%s*$"] = "end",
		["begin%s*$"] = "end",
	},
	php = {
		["if%s*$"] = "endif;",
		["foreach%s*$"] = "endforeach;",
		["for%s*$"] = "endfor;",
		["while%s*$"] = "endwhile;",
		["switch%s*$"] = "endswitch;",
		["function%s*$"] = "endfunction;",
		["do%s*$"] = "while (true);",
	},
}

rules.bash = rules.sh
rules.zsh = rules.sh
rules.ada = rules.pascal
rules.plsql = rules.sql
rules.postgres = rules.sql

vim.api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(rules),
	callback = function(args)
		vim.keymap.set("i", "<CR>", function()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local before_cursor = line:sub(1, col)

			local current_rules = rules[args.match]
			if not current_rules then
				return
			end

			for pat, close in pairs(current_rules) do
				if before_cursor:match(pat) then
					vim.snippet.expand("\n\t$0\n" .. close)
					return
				end
			end

			local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
			vim.api.nvim_feedkeys(cr, "n", true)
		end, { silent = true, buffer = args.buf })
	end,
})
