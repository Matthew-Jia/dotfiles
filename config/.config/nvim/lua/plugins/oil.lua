return {
	'stevearc/oil.nvim',
	opts = {
		view_options = { show_hidden = true },
		keymaps = {
			-- disable for window switching
			["<C-h>"] = false,
			["<C-l>"] = false,
		},
	},
	keys = {{"-", "<cmd>Oil<CR>"}},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
}
