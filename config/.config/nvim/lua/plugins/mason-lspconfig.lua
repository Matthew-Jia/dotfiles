return {
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
}
