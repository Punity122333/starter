return {
	{
		"nvim-mini/mini.nvim",
		opts = {
			operators = {
				evaluate = {
					prefix = "gm=",
					func = function(content)
						local expr = table.concat(content.lines, "\n")
						local f, err = load("return " .. expr)
						if f then
							local ok, res = pcall(f)
							if ok then
								return vim.split(tostring(res), "\n")
							end
						end
						return content.lines
					end,
				},
				exchange = { prefix = "gmx" },
				multiply = { prefix = "gmm" },
				replace = { prefix = "gmr" },
				sort = { prefix = "gms" },
			},
		},
		config = function(_, opts)
			require("mini.operators").setup(opts.operators)
		end,
	},
}
