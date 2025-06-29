return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local jdtls_cfg = { capabilities = capabilities }
    local ok, jdtls = pcall(require, "jdtls")
    if ok then
      jdtls.start_or_attach(jdtls_cfg)
    end
  end,
}
