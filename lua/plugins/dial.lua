return {
	"monaqa/dial.nvim",
	opts = function(_, opts)
		local augend = require("dial.augend")

		opts.dials_by_ft = opts.dials_by_ft or {}

		vim.schedule(function()
			local config = require("dial.config")
			local base = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
        augend.integer.alias.decimal_int,
        augend.integer.alias.octal,
        augend.integer.alias.binary,
				augend.constant.alias.bool,
			}
			config.augends:register_group({
				default = base,
				cpp = base,
			})
		end)

		return opts
	end,
}

