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


local cmd = function(command)
	return function()
		vim.cmd(command)
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
		{
			"folke/tokyonight.nvim",
			priority = 1000,
			config = function()
				local transparent = true

				local bg = "#011628"
				local bg_dark = "#011423"
				local bg_highlight = "#143652"
				local bg_search = "#0A64AC"
				local bg_visual = "#275378"
				local fg = "#CBE0F0"
				local fg_dark = "#B4D0E9"
				local fg_gutter = "#627E97"
				local border = "#547998"

				require("tokyonight").setup({
					transparent = transparent,
					styles = {
						sidebars = transparent and "transparent" or "dark",
						floats = transparent and "transparent" or "dark",
					},
					on_colors = function(colors)
						colors.bg = bg
						colors.bg_dark = transparent and colors.none or bg_dark
						colors.bg_float = transparent and colors.none or bg_dark
						colors.bg_highlight = bg_highlight
						colors.bg_popup = bg_dark
						colors.bg_search = bg_search
						colors.bg_sidebar = transparent and colors.none or bg_dark
						colors.bg_statusline = transparent and colors.none or bg_dark
						colors.bg_visual = bg_visual
						colors.border = border
						colors.fg = fg
						colors.fg_dark = fg_dark
						colors.fg_float = fg
						colors.fg_gutter = fg_gutter
						colors.fg_sidebar = fg_dark
					end,
				})

				vim.cmd("colorscheme tokyonight")
			end,
		},
		{
			"Pocco81/auto-save.nvim",
			lazy = false, -- load on startup
			enabled = true, -- auto-save is active right away
			opts = { trigger_events = { "InsertLeave", "FocusLost" } },
		},
		{
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
		},
		{
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
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			opts = {
				keymap = { preset = "super-tab" },
				signature = { enabled = true },
			},
		},
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate",
			config = true,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				vim.diagnostic.config({
					virtual_text = true,
					signs = true,
					underline = true,
					float = { border = "rounded" },
					update_in_insert = false,
				})

				local mason_lspconfig = require("mason-lspconfig")

				mason_lspconfig.setup({
					ensure_installed = {
						"clangd",
						"lua_ls",
						"pyright",
						"gopls",
						"rust_analyzer",
						"ts_ls",
						"zls",
						"ocamllsp",
						"tinymist",
						"neocmake",
					},
					automatic_installation = true,
				})

				local lspconfig = require("lspconfig")
				local capabilities = vim.lsp.protocol.make_client_capabilities()

				mason_lspconfig.setup_handlers({
					-- Default handler for most servers
					function(server)
						lspconfig[server].setup({
							capabilities = capabilities,
						})
					end,

					-- Override clangd to use your Homebrew binary
					["clangd"] = function()
						lspconfig.clangd.setup({
							capabilities = capabilities,
							cmd = { "/opt/homebrew/opt/llvm/bin/clangd" },
						})
					end,

					-- Override tinymist to set filetypes
					["tinymist"] = function()
						lspconfig.tinymist.setup({
							capabilities = capabilities,
							cmd = { "tinymist" },
							filetypes = { "typst" },
						})
					end,
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = { "c", "cpp", "markdown", "markdown_inline" },
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "echasnovski/mini.icons" },
			keys = function()
				local fzf = require("fzf-lua")
				return {
					{ "<leader>ff", function() fzf.files({ hidden = false }) end, desc = "[F]ind [F]iles", },
					{ "<leader>fa", function() fzf.files() end, desc = "[F]ind [A]ll files", },
					{ "<leader>fd", function() fzf.files({ cwd = "~/dotfiles", hidden = true }) end, desc = "[F]ind [D]otfiles", },
					{ "<leader>fg", function() fzf.live_grep() end, desc = "[F]ind by [G]rep", },
					{ "<leader>/", function() fzf.blines() end, desc = "[/] Search in buffer" },
					{ "gd", function() fzf.lsp_definitions() end, desc = "Go to [D]efinition" },
					{ "gr", function() fzf.lsp_references() end, desc = "Go to [R]eferences" },
					{ "gi", function() fzf.lsp_implementations() end, desc = "Go to [I]mplementation" },
				}
			end,
			opts = {},
		},
		{
			"lervag/vimtex",
			-- ft = "tex",
			init = function()
				vim.g.vimtex_view_method = "skim"
				vim.g.vimtex_compiler_method = "latexmk"
				vim.g.vimtex_compiler_latexmk = { aux_dir = 'aux_build', out_dir = 'build' }
			end,
		},
		{
			'stevearc/oil.nvim',
			opts = {
				view_options = { show_hidden = true },
				keymaps = {
					-- disable for window switching
					["<C-h>"] = false,
					["<C-l>"] = false,
				},
			},
			keys = {{"-", cmd("Oil")}},
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
		},
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			opts = {},
			keys = {
				{ "<leader>tf", cmd("ToggleTerm direction=float"),      desc = "Toggle floating terminal" },
				{ "<leader>th", cmd("ToggleTerm direction=horizontal"), desc = "Toggle horizontal terminal" },
				{ "<leader>tv", cmd("ToggleTerm direction=vertical"),   desc = "Toggle vertical terminal" },
			},
		},
		{
			"tpope/vim-fugitive",
			cmd = { "Git", "G", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite" },
		},
		-- {
		-- 	"github/copilot.vim",
		-- 	lazy = true,
		-- 	cmd = { "Copilot" },      -- ensures :Copilot exists on demand
		-- 	event = "InsertEnter",    -- also loads when you start typing
		-- 	config = function()
		-- 		vim.g.copilot_no_tab_map = true
		-- 		vim.api.nvim_set_keymap("i", "<Right>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		-- 	end,
		-- },
		{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },
		{ "christoomey/vim-tmux-navigator", lazy = false },
		{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
		{ "folke/snacks.nvim" },
		{
			"echasnovski/mini.pairs",
			version = false,
			event = "InsertEnter",
			opts = {
				mappings = {
					["$"] = { action = "closeopen", pair = "$$", neigh_pattern = "[^\\].", register = { cr = false } },
				},
			},
			config = function(_, opts)
				require("mini.pairs").setup(opts)

				-- Define the logic in a reusable function
				local function setup_tex_pairs()
					vim.keymap.set("i", "$", "$$<Left>", { buffer = true, silent = true })
					vim.keymap.set("i", "\\[", "\\[  \\]<Left><Left><Left>", { buffer = true, silent = true })
					vim.keymap.set("i", "\\{", "\\{  \\}<Left><Left><Left>", { buffer = true, silent = true })
				end

				-- 1. Handle files opened via the command line (Current Buffer)
				if vim.bo.filetype == "tex" then
					setup_tex_pairs()
				end

				-- 2. Handle files opened later (Autocmd)
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "tex",
					callback = setup_tex_pairs,
				})
			end,
		},
		{ "echasnovski/mini.comment", version = false, opts = {}, event = { "BufReadPre", "BufNewFile" } },
		{ "neovim/nvim-lspconfig" },
		{ "kylechui/nvim-surround", config = true, event = { "BufReadPre", "BufNewFile" } },
	},
}
)
