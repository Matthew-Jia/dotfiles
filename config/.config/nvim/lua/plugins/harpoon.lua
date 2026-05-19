return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>hm",
			function()
				require("harpoon.mark").add_file()
			end,
			desc = "Mark file",
		},
		{
			"<leader>hh",
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			desc = "Harpoon menu",
		},
	},
}

