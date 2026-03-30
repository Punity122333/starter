local function is_online()
	local result = vim.system(
		{ "curl", "-s", "--max-time", "1", "-o", "/dev/null", "-w", "%{http_code}", "https://1.1.1.1" },
		{ text = true }
	):wait()
	return result.stdout ~= nil and result.stdout ~= "000"
end

return {
	{
		"yetone/avante.nvim",
    event = "VeryLazy",
		version = false,
		build = "make",
		opts = {
			notify = false,
			mode = "agentic",
			provider = "gemini",
			instructions_file = "avante.md",
			providers = {
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "gpt-5-mini",
					proxy = nil,
					allow_insecure_call = true,
					timeout = 5000,
				},
			},
			behaviour = {
				enable_cursor_planning_mode = true,
				auto_suggestions = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
				notify = false,
			},
			input = {
				provider = "snacks",
			},
			mappings = {
				ask = "<leader>aa",
				edit = "<leader>ae",
				refresh = "<leader>ar",
				focus = "<leader>af",
				toggle = {
					default = "<leader>at",
					debug = "<leader>ad",
					hint = "<leader>ah",
					suggestion = "<leader>as",
					repology = "<leader>ar",
				},
			},
			windows = {
				position = "right",
				width = 23,
				wrap = true,
				sidebar_header = {
					enabled = true,
					align = "center",
					rounded = true,
				},
				border = "rounded",
				ask = {
					start_insert = false,
					border = "rounded",
				},
				edit = {
					border = "rounded",
				},
			},
			suggestion = {
				throttle = 1000,
				debounce = 500,
			},
		},
		config = function(_, opts)
			require("avante").setup(opts)

			vim.api.nvim_create_autocmd("InsertEnter", {
				callback = function()
					if not is_online() then
						local ok, suggestion = pcall(require, "avante.suggestion")
						if ok and suggestion.stop then
							pcall(suggestion.stop)
						end
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "AvantePostSetup",
				once = true,
				callback = function()
					local ok, suggestion = pcall(require, "avante.suggestion")
					if not ok then
						return
					end

					if suggestion._suggest then
						local original = suggestion._suggest
						suggestion._suggest = function(...)
							if not is_online() then
								return
							end
							local ok2, err = pcall(original, ...)
							if not ok2 then
							end
						end
					end
				end,
			})
		end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
