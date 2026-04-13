return {
	{
		"nvim-mini/mini.icons",
    lazy = false,
		opts = function(_, opts)
			opts.extension = opts.extension or {}
			opts.extension.regex = { glyph = "󰑑", hl = "MiniIconsBlue" }

			opts.file = opts.file or {}
			opts.file[".gitignore"] = { glyph = "", hl = "MiniIconsRed" }
		end,
	},
	{

		"nvim-tree/nvim-web-devicons",
    enabled = false,
		opts = {
			strict = true,
			override_by_extension = {
				["regex"] = {
					icon = "󰑑",
					color = "#00d8f0",
					name = "Regex",
				},
			},
			override_by_filename = {
				[".gitignore"] = {
					icon = "",
					color = "#f54d27",
					name = "GitIgnore",
				},
			},
		},
	},
}
