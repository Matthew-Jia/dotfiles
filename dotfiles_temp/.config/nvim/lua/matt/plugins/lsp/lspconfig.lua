-- Plugin: nvim-lspconfig with DRY setup
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- Common on_attach for all servers
    local on_attach = function(client, bufnr)
      -- disable all formatting on save
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      -- buffer-local keymaps
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local mappings = {
        { mode = "n", lhs = "gD", rhs = vim.lsp.buf.declaration, desc = "Go to declaration" },
        { mode = "n", lhs = "gd", rhs = "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
        { mode = "n", lhs = "gR", rhs = "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
        { mode = "n", lhs = "gi", rhs = "<cmd>Telescope lsp_implementations<CR>", desc = "LSP implementations" },
        { mode = "n", lhs = "gt", rhs = "<cmd>Telescope lsp_type_definitions<CR>", desc = "LSP type defs" },
        { mode = { "n", "v" }, lhs = "<leader>ca", rhs = vim.lsp.buf.code_action, desc = "Code actions" },
        { mode = "n", lhs = "<leader>rn", rhs = vim.lsp.buf.rename, desc = "Rename symbol" },
        { mode = "n", lhs = "<leader>D", rhs = "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer diagnostics" },
        { mode = "n", lhs = "<leader>d", rhs = vim.diagnostic.open_float, desc = "Line diagnostics" },
        { mode = "n", lhs = "[d", rhs = vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
        { mode = "n", lhs = "]d", rhs = vim.diagnostic.goto_next, desc = "Next diagnostic" },
        { mode = "n", lhs = "K", rhs = vim.lsp.buf.hover, desc = "Hover docs" },
        { mode = "n", lhs = "<leader>rs", rhs = ":LspRestart<CR>", desc = "Restart LSP" },
      }
      for _, m in ipairs(mappings) do
        keymap.set(m.mode, m.lhs, m.rhs, vim.tbl_extend("force", opts, { desc = m.desc }))
      end
    end

    -- enhance capabilities for autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- custom diagnostic signs
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- List of servers to setup uniformly
    local servers = {
      html = {},
      ts_ls = {},
      cssls = {},
      tailwindcss = {},
      prismals = {},
      graphql = { filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" } },
      emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },
      pyright = { settings = { pyright = { analyses = {}, staticcheck = false } } },
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { enable = false },
            workspace = {
              library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.stdpath("config") .. "/lua"] = true },
            },
          },
        },
      },
      gopls = {
        settings = {
          gopls = { analyses = { unusedparams = true, unreachable = true, nilness = true }, staticcheck = false },
        },
      },
      clangd = { settings = { clangd = { analyses = {}, staticcheck = false } } },
    }

    for name, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      cfg.on_attach = on_attach
      lspconfig[name].setup(cfg)
    end

    -- Svelte: extra post-write hook
    lspconfig.svelte.setup(vim.tbl_extend("force", servers.svelte or {}, {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
            end
          end,
        })
      end,
    }))
  end,
}
