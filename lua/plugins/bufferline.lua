local function goto_buffer(count)
	require("bufferline").go_to(count, true)
end

local BufferKeys = {
  {
    "<leader>ba",
    function()
      goto_buffer(1)
    end,
    desc = "Go to absolute buffer 1",
  },
	{
    "<leader>bs",
    function()
      goto_buffer(2)
    end,
    desc = "Go to absolute buffer 2",
	},
  {
    "<leader>bd",
    function()
      goto_buffer(3)
    end,
    desc = "Go to absolute buffer 3",
  },
  {
    "<leader>bf",
    function()
      goto_buffer(4)
    end,
    desc = "Go to absolute buffer 4",
  },
	{
		"<leader>bg",
		function()
			goto_buffer(5)
		end,
		desc = "Go to absolute buffer 5",
	},
	{
		"<leader>bh",
		function()
			goto_buffer(6)
		end,
		desc = "Go to absolute buffer 6",
	},
	{
		"<leader>bj",
		function()
			goto_buffer(7)
		end,
		desc = "Go to absolute buffer 7",
	},
	{
		"<leader>bk",
		function()
			goto_buffer(8)
		end,
		desc = "Go to absolute buffer 8",
	},
	{
		"<leader>bl",
		function()
			goto_buffer(9)
		end,
		desc = "Go to absolute buffer 9",
	},
	{
		"<leader>b;",
		function()
			goto_buffer(10)
		end,
		desc = "Go to absolute buffer 10",
	},
	{
		"<leader>b'",
		function()
			goto_buffer(11)
		end,
		desc = "Go to absolute buffer 11",
	},
}

local GodBg = "#1a1b26"
local LightBlue = "#82aaff"

return {
	{
		"akinsho/bufferline.nvim",
		keys = BufferKeys,
		opts = function()
			return {
				options = {
					always_show_bufferline = false,
					indicator = {
						icon = "▎",
						style = "icon",
					},
					separator_style = "thin",
					diagnostics = "nvim_lsp",
					numbers = function(numberopts)
						local lettermap = { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'" }
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
						if vim.bo[buf_number].filetype == "rconsole" then
							return false
						end
						return true
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
			}
		end,
	},
}
