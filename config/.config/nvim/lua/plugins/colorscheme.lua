return {
	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {
		transparent = true, -- This handles the main background, gutter, and float/sidebar defaults
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		-- You only need on_highlights if you want to fix specific UI elements 
		-- that the transparency toggle might miss (like Conceal).
		on_highlights = function(hl, c)
			hl.Conceal = {
				fg = c.fg,
				bg = "NONE",
			}
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd("colorscheme tokyonight")
	end,
}
