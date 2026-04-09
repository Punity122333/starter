return {
	"monaqa/dial.nvim",
	opts = function(_, opts)
		local augend = require("dial.augend")

		-- Extend whatever LazyVim already put in opts
		opts.dials_by_ft = opts.dials_by_ft or {}

		-- Register your custom groups after LazyVim's setup
		vim.schedule(function()
			local config = require("dial.config")
			local base = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
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
