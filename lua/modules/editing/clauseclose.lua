local api = vim.api
local expand = vim.snippet.expand
local feedkeys = api.nvim_feedkeys
local get_line = api.nvim_get_current_line
local get_cursor = api.nvim_win_get_cursor
local ts_get_node = vim.treesitter.get_node

local CR = api.nvim_replace_termcodes("<CR>", true, false, true)

local function in_nontrigger_context()
	local ok, node = pcall(ts_get_node)
	if not ok or not node then return false end
	while node do
		local t = node:type()
		if t:find("string", 1, true) or t:find("comment", 1, true) then
			return true
		end
		node = node:parent()
	end
	return false
end

local rules = {
	lua = {
		{ "{%s*$",        ""      },
		{ "then%s*$",     "end"   },
		{ "do%s*$",       "end"   },
		{ "function%s*$", "end"   },
		{ "repeat%s*$",   "until" },
	},
	sh = {
		{ "{%s*$",    "}"    },
		{ "then%s*$", "fi"   },
		{ "do%s*$",   "done" },
		{ "in%s*$",   "esac" },
	},
	["vim"] = {
		{ "if%s*$",       "endif"       },
		{ "for%s*$",      "endfor"      },
		{ "while%s*$",    "endwhile"    },
		{ "function%s*$", "endfunction" },
		{ "augroup%s*$",  "augroup END" },
		{ "try%s*$",      "endtry"      },
		{ "lua%s*$",      "end"         },
	},
	cobol = {
		{ "then%s*$",     "END-IF"       },
		{ "perform%s*$",  "END-PERFORM"  },
		{ "evaluate%s*$", "END-EVALUATE" },
	},
	fortran = {
		{ "then%s*$",  "end if"    },
		{ "do%s*$",    "end do"    },
		{ "where%s*$", "end where" },
	},
	pascal = {
		{ "begin%s*$", "end"      },
		{ "then%s*$",  "end if"   },
		{ "loop%s*$",  "end loop" },
	},
	sql = {
		{ "begin%s*$", "end"      },
		{ "then%s*$",  "end if"   },
		{ "loop%s*$",  "end loop" },
	},
	ruby = {
		{ "if%s*$",     "end" },
		{ "unless%s*$", "end" },
		{ "def%s*$",    "end" },
		{ "class%s*$",  "end" },
		{ "module%s*$", "end" },
		{ "do%s*$",     "end" },
		{ "while%s*$",  "end" },
		{ "for%s*$",    "end" },
		{ "begin%s*$",  "end" },
	},
	php = {
		{ "foreach%s*$",  "endforeach;"   },
		{ "if%s*$",       "endif;"        },
		{ "for%s*$",      "endfor;"       },
		{ "while%s*$",    "endwhile;"     },
		{ "switch%s*$",   "endswitch;"    },
		{ "function%s*$", "endfunction;"  },
		{ "do%s*$",       "while (true);" },
	},
}

rules.bash = rules.sh
rules.zsh = rules.sh
rules.ada = rules.pascal
rules.plsql = rules.sql
rules.postgres = rules.sql

local seen = {}
for _, ft_rules in pairs(rules) do
	if not seen[ft_rules] then
		seen[ft_rules] = true
		for _, entry in ipairs(ft_rules) do
			entry[2] = "\n\t$0\n" .. entry[2]
		end
	end
end

api.nvim_create_autocmd("FileType", {
	pattern = vim.tbl_keys(rules),
	callback = function(args)
		local current_rules = rules[args.match]

		vim.keymap.set("i", "<CR>", function()
			local col = get_cursor(0)[2]
			local before_cursor = get_line():sub(1, col)

			for _, entry in ipairs(current_rules) do
				if before_cursor:match(entry[1]) then
					-- Only pay for TS walk when a pattern actually fires
					if not in_nontrigger_context() then
						expand(entry[2])
						return
					end
					break -- matched inside string/comment → fall through to CR
				end
			end

			feedkeys(CR, "n", true)
		end, { silent = true, buffer = args.buf })
	end,
})



