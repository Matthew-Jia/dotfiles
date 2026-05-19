vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.wrap = false
opt.linebreak = false
opt.breakindent = true
opt.showbreak = "↪ "
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")

local del = vim.keymap.del
local set = vim.keymap.set

del("n", "gri")
del("n", "grr")
del("n", "gra")
del("n", "grn")

set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
set("n", "x", '"_x', { desc = "Delete character without copying to register" })
set("n", "<leader>tw", "<cmd>set wrap! linebreak!<CR>", { desc = "Toggle line wrap" })
set("n", "j", "gj", { desc = "Down by screen line" })
set("n", "k", "gk", { desc = "Up by screen line" })
set("n", "^", '(&wrap ? "g^" : "^")', { expr = true, silent = true, desc = "Smart ^ (screen or real line)" })
set("n", "$", '(&wrap ? "g$" : "$")', { expr = true, silent = true, desc = "Smart $ (screen or real line)" })
set("v", "j", "gj", { desc = "Visual down by screen line" })
set("v", "k", "gk", { desc = "Visual up by screen line" })
set("v", "^", '(&wrap ? "g^" : "^")', { expr = true, silent = true, desc = "Smart visual ^" })
set("v", "$", '(&wrap ? "g$" : "$")', { expr = true, silent = true, desc = "Smart visual $" })
set("n", "<leader>tt", function()
	local ts = vim.bo.tabstop -- current width
	local new = (ts == 4) and 2 or 4 -- flip 4→2 or 2→4
	vim.bo.tabstop = new
	vim.bo.shiftwidth = new
	vim.bo.softtabstop = new
	vim.notify("Tab width set to " .. new)
end, { desc = "Toggle tab width 2↔4" })

set("n", "<leader>dd", '"_dd', { desc = "Delete without copying to the default register" })
set("x", "<leader>d", '"_d', { desc = "Delete without copying to the default register" })
set("x", "<leader>p", '"_dP', { desc = "Paste without copying to the default register" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ "tpope/vim-fugitive", cmd = { "Git", "G", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite" } },
		{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },
		{ "christoomey/vim-tmux-navigator", lazy = false },
		{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
		{ "folke/snacks.nvim" },
		{ "echasnovski/mini.comment", version = false, opts = {}, event = { "BufReadPre", "BufNewFile" } },
		{ "kylechui/nvim-surround", config = true, event = { "BufReadPre", "BufNewFile" } },

		{ import = "plugins" },
	},
}
)
