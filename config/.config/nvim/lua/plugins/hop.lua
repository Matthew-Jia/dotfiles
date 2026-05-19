return {
	"phaazon/hop.nvim",
	branch = "v2",
	config = function()
		require("hop").setup()
		vim.opt.termguicolors = true

		vim.cmd([[
					highlight HopNextKey   guifg=#ff0000 gui=bold ctermfg=red cterm=bold
					highlight HopNextKey1  guifg=#ff8800 gui=bold ctermfg=208 cterm=bold
					highlight HopNextKey2  guifg=#ffff00 gui=bold ctermfg=yellow cterm=bold
					highlight HopUnmatched guifg=#444444
					]])
		vim.keymap.set("n", "<leader>w", ":HopWord<CR>", { silent = true })
		vim.keymap.set("n", "<leader>l", ":HopLine<CR>", { silent = true })
	end,
}
