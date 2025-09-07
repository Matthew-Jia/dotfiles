-- plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig    = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap       = vim.keymap

    -- common on_attach
    local function on_attach(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local mappings = {
        { "n", "gD", vim.lsp.buf.declaration,  "Go to declaration" },
        { "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "LSP definitions" },
        -- …etc…
        { "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
      }
      for _, m in ipairs(mappings) do
        keymap.set(m[1], m[2], m[3],
          vim.tbl_extend("force", opts, { desc = m[4] })
        )
      end
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN ] = "",
          [vim.diagnostic.severity.INFO ] = "",
          [vim.diagnostic.severity.HINT ] = "",
        },
      },
    })

    local function setup(name, opts)
      opts = vim.tbl_extend("force", {
        on_attach    = on_attach,
        capabilities = capabilities,
      }, opts or {})
      lspconfig[name].setup(opts)
    end

    -- just a list of server names
    local servers = {
      "pyright",
      "gopls",
      "clangd",
      "lua_ls",
    }

    -- use ipairs to iterate an array of names
    for _, name in ipairs(servers) do
      setup(name)  -- no second arg ⇒ opts defaults to {}
    end

		-- 1. Enable virtual text (inline error messages) and underlines
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",      -- could be "", "", etc.
				spacing = 4,
			},
			signs = true,        -- you already have signs configured
			underline = true,     -- underline text with errors/warnings
			update_in_insert = false,  -- don’t spam while you’re typing
			severity_sort = true,  -- show more severe diagnostics first
		})

		-- 2. Show a floating diagnostic window when you hover
		vim.o.updatetime = 250  -- trigger CursorHold after 250ms of inactivity
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				vim.diagnostic.open_float(nil, {
					focusable = false,
					border    = "rounded",
					source    = "always",  -- show the “source=” line
					header    = "",
					prefix    = "",
				})
			end,
		})
  end,
}
