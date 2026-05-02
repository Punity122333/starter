local lettermap = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'" }

local BufferKeys = {}
for i, key in ipairs(lettermap) do
	table.insert(BufferKeys, {
		"<leader>b" .. key,
		function()
			require("bufferline").go_to(i, true)
		end,
		desc = "Go to buffer " .. i,
	})
end

local GodBg = "#1a1b26"
local LightBlue = "#82aaff"

return {
	{
		"akinsho/bufferline.nvim",
		lazy = false,
		keys = BufferKeys,
		opts = {
			options = {
				always_show_bufferline = false,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				separator_style = "thin",
				diagnostics = "nvim_lsp",
				numbers = function(numberopts)
					local letter = lettermap[numberopts.ordinal] or tostring(numberopts.ordinal)
					return string.format("%d (%s)", numberopts.ordinal, letter)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "file explorer",
						highlight = "directory",
						text_align = "left",
						padding = 0,
					},
					{
						filetype = "rconsole",
						text = "r console",
						highlight = "directory",
						text_align = "left",
						padding = 0,
					},
				},
				filter_callback = function(buf_number, _)
					return vim.bo[buf_number].filetype ~= "rconsole"
				end,
			},
			highlights = {
				fill = { bg = GodBg },
				background = { bg = GodBg },
				separator = { fg = GodBg, bg = GodBg },
				separator_visible = { fg = GodBg, bg = GodBg },
				separator_selected = { fg = GodBg, bg = GodBg },
				indicator_selected = {
					fg = LightBlue,
					bg = GodBg,
				},
				buffer_visible = { bg = GodBg },
				buffer_selected = {
					bg = GodBg,
					fg = LightBlue,
					bold = true,
					italic = false,
				},
				offset_separator = { fg = GodBg, bg = GodBg },
				numbers = { fg = "#7aa2f7", bg = GodBg, bold = true },
				numbers_selected = { fg = "#fa7355", bg = GodBg, bold = true },
				close_button = { bg = GodBg },
				close_button_visible = { bg = GodBg },
				close_button_selected = { bg = GodBg },
				modified = { bg = GodBg },
				modified_visible = { bg = GodBg },
				modified_selected = { bg = GodBg },
				hint_visible = { bg = GodBg },
				info_visible = { bg = GodBg },
				warning_visible = { bg = GodBg },
				error_visible = { bg = GodBg },
				diagnostic_visible = { bg = GodBg },
			},
		},
	},
}
