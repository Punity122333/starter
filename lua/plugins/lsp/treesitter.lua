vim.opt.rtp:prepend(vim.fn.expand("~/.local/share/nvim/site"))

local DISABLED_FT = {
	help                 = true,
	dashboard            = true,
	avante               = true,
	["avante-input"]     = true,
	gitcommit            = true,
	markdown             = true,
	oil                  = true,
	TelescopePrompt      = true,
	alpha                = true,
	NvimTree             = true,
	snacks_picker_list    = true,
	snacks_picker_preview = true,
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy  = false,
		build = ":TSUpdate",
		opts  = {
			ensure_installed = {
				"c", "cpp", "lua", "vim", "vimdoc", "query",
				"typescript", "tsx", "javascript",
				"css", "html", "glsl", "hlsl", "wgsl",
			},
			sync_install  = false,
			auto_install  = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function(lang, buf)
					if vim.wo.diff then return true end

					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > 100 * 1024 then return true end

					if DISABLED_FT[vim.bo[buf].filetype] then return true end

					if (lang == "c" or lang == "cpp") and vim.api.nvim_buf_line_count(buf) > 1000 then
						return true
					end
				end,
			},
			indent               = { enable = false },
			incremental_selection = { enable = false, keymaps = {} },
		},
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },
}

