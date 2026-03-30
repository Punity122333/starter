return {
	{
		"Punity122333/snipe.nvim",
		-- dir = "~/dev/projects/snipe.nvim",
		branch = "master",
		lazy = false,
		priority = 1000,
		keys = {
      {
        "<leader>ff",
        function()
          require("snipe.nav").files()
        end,
        desc = "files (fd)",
      },
			{
				"<leader>fb",
				function()
					require("snipe.nav").buffers()
				end,
				desc = "buffers",
			},
			{
				"<leader>f'",
				function()
					require("snipe.nav").marks()
				end,
				desc = "marks",
			},
			{
				"<leader>fr",
				function()
					require("snipe.nav").references()
				end,
				desc = "LSP references",
			},
			{
				"<leader>fo",
				function()
					require("snipe.nav").oldfiles()
				end,
				desc = "recent files",
			},
			{
				"<leader>fj",
				function()
					require("snipe.nav").projects()
				end,
				desc = "projects",
			},
			{
				"<leader>fd",
				function()
					require("snipe.nav").diagnostics(false)
				end,
				desc = "diagnostics (buffer)",
			},
			{
				"<leader>f;",
				function()
					require("snipe.nav").diagnostics(true)
				end,
				desc = "diagnostics (workspace)",
			},

			{
				"<leader>sa",
				function()
					require("snipe.search").autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sc",
				function()
					require("snipe.search").cmdhistory()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					require("snipe.search").commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sg",
				function()
					require("snipe.search").grep()
				end,
				desc = "Grep (root)",
			},
			{
				"<leader>s.",
				function()
					require("snipe.search").grep_cwd()
				end,
				desc = "Grep (cwd)",
			},
			{
				"<leader>sh",
				function()
					require("snipe.search").help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					require("snipe.search").highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>si",
				function()
					require("snipe.search").icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					require("snipe.search").jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					require("snipe.search").keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					require("snipe.search").loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sM",
				function()
					require("snipe.search").manpages()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sp",
				function()
					require("snipe.search").plugins()
				end,
				desc = "Plugin Spec",
			},
			{
				"<leader>sq",
				function()
					require("snipe.search").quickfix()
				end,
				desc = "Quickfix",
			},
			{
				"<leader>su",
				function()
					require("snipe.search").undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>sw",
				function()
					require("snipe.search").grep_word(true)
				end,
				desc = "Grep Word (root)",
			},
			{
				"<leader>sW",
				function()
					require("snipe.search").grep_word(false)
				end,
				desc = "Grep Word (cwd)",
			},
			{
				'<leader>s"',
				function()
					require("snipe.search").registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					require("snipe.search").searchhistory()
				end,
				desc = "Search History",
			},
			{
				"<leader>sn",
				function()
					require("snipe.search").noice()
				end,
				desc = "Noice History",
			},
			{
				"<leader>fw",
				function()
					require("snipe.rg").rg()
				end,
				desc = "grep (fast)",
			},
			{
				"<leader>/",
				function()
					require("snipe.rg").rg()
				end,
				desc = "grep (fast)",
			},
		},
		opts = {
			keys = false,
		},
		config = function(_, opts)
			require("snipe").setup(opts)
		end,
	},
}
