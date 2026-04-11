return {
	"gbprod/yanky.nvim",
  lazy = false,
	dependencies = { "kkharji/sqlite.lua" },
	event = "VeryLazy",
	opts = {
		ring = {
			history_length = 100,
			storage = "shada",
			sync_with_numbered_registers = true,
			cancel_event = "update",
			ignore_registers = { "_" },
			update_register_on_cycle = false,
		},
		system_clipboard = {
			sync_with_ring = false,
		},
		highlight = {
			on_put = true,
			on_yank = true,
			timer = 200,
		},
		preserve_cursor_position = {
			enabled = true,
		},
	},
}
