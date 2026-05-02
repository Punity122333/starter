return {
	{
		"nvim-mini/mini.nvim",
    lazy = false,
		opts = {
			operators = {
				evaluate = {
					prefix = "gz=",
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
				exchange = { prefix = "gzx" },
				multiply = { prefix = "gzm" },
				replace = { prefix = "gzr" },
				sort = { prefix = "gzr" },
			},
		},
		config = function(_, opts)
			require("mini.operators").setup(opts.operators)
		end,
	},
}
