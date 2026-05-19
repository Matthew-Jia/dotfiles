return {
	"Pocco81/auto-save.nvim",
	lazy = false, -- load on startup
	enabled = true, -- auto-save is active right away
	opts = { trigger_events = { "InsertLeave", "FocusLost" } },
}
