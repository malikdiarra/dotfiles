require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = {"gopls", "jdtls"} })
vim.lsp.set_log_level('debug')
local util = require("lspconfig/util")
wk = require("which-key")

local on_attach = function(client, bufnr)
  wk.add({
    { "<leader>n", group = "Navigation - LSP" },
    { "<leader>nci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", desc = "View incoming calls" },
    { "<leader>nco", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", desc = "View outgoing calls" },
    { "<leader>nd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition" },
    { "<leader>ni", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to implementation" },
    { "<leader>nn", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Show type definition" },
    { "<leader>nr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Go to references" },
    { "<leader>ns", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "Show symbols" },
  })

  wk.add({
    { "<leader>a", group = "Action - LSP" },
    { "<leader>aa", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code action" },
    { "<leader>af", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format" },
    { "<leader>ar", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
  })

  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true, buffer = bufnr})

  vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", {noremap = true, silent = true, buffer = bufnr})

  vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", {noremap = true, silent = true, buffer = bufnr})

  vim.keymap.set("n", "]q", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "[q", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.diagnostic.open_float(0, {scope = 'line'})<CR>", {noremap = true, silent = true, buffer = bufnr})
end

vim.lsp.set_log_level('debug')

require("lspconfig").gopls.setup {
  on_attach = on_attach,
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
