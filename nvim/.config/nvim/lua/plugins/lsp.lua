require("mason").setup()
require("mason-lspconfig").setup({})
vim.lsp.set_log_level('warn')
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

  wk.add({
    { "<leader>w", group = "Workspace management - LSP"},
    { "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", desc = "Add workspace" },
    { "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", desc = "Remove workspace" },
    { "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "List workspaces" },
  })

  vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", {noremap = true, silent = true, buffer = bufnr})

  vim.keymap.set("n", "]q", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "[q", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<leader>ls", "<cmd>lua vim.diagnostic.open_float(0, {scope = 'line'})<CR>", {noremap = true, silent = true, buffer = bufnr})

  --if client:supports_method('textDocument/completion') then
  --    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
  --end

  local augrp = vim.api.nvim_create_augroup("document_highlight_" .. bufnr, { clear = true })
  if client:supports_method('textDocument/documentHighlight') then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function() vim.lsp.buf.document_highlight() end,
      buffer = bufnr,
      group = augrp,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function() vim.lsp.buf.clear_references() end,
      buffer = bufnr,
      group = augrp,
    })
  end
end


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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Helper function to find the Python workspace root with uv workspace
local function find_python_workspace_root(fname)
  -- Search upward from the file looking for a pyproject.toml with [tool.uv.workspace]
  local current_dir = vim.fn.fnamemodify(fname, ':p:h')

  while current_dir and current_dir ~= '/' do
    local pyproject_path = current_dir .. "/pyproject.toml"
    local file = io.open(pyproject_path, "r")
    if file then
      local content = file:read("*all")
      file:close()
      -- Check if this pyproject.toml contains workspace configuration
      if content:match("%[tool%.uv%.workspace%]") then
        return current_dir
      end
    end
    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- Fallback to standard patterns if no workspace found
  return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
end

-- Helper function to find the Python virtual environment
local function find_python_venv(workspace_root)
  -- Common virtual environment directory names
  local venv_names = {".venv", "venv", ".virtualenv", "env"}

  for _, venv_name in ipairs(venv_names) do
    local venv_path = workspace_root .. "/" .. venv_name .. "/bin/python"
    local file = io.open(venv_path, "r")
    if file then
      file:close()
      return venv_path
    end
  end

  -- Fallback to system Python
  return nil
end

require("lspconfig").jedi_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = find_python_workspace_root,
  on_new_config = function(config, root_dir)
    local venv = find_python_venv(root_dir)
    if venv then
      config.init_options = config.init_options or {}
      config.init_options.workspace = config.init_options.workspace or {}
      config.init_options.workspace.environmentPath = venv
    end
  end,
}

require("lspconfig").vtsls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
