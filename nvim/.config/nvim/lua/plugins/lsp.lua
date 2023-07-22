require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = {"gopls", "jdtls"} })
vim.lsp.set_log_level('debug')
local util = require("lspconfig/util")

require("lspconfig").gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  }
}
