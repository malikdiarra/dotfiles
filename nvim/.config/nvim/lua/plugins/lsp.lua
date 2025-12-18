require("mason").setup()
require("mason-lspconfig").setup({})
vim.lsp.set_log_level('warn')
local util = require("lspconfig/util")
wk = require("which-key")

local on_attach = function(client, bufnr)
  -- Quick access to most common operations
  wk.add({
    { "<leader>h", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover documentation", buffer = bufnr },
    { "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next diagnostic", buffer = bufnr },
    { "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous diagnostic", buffer = bufnr },
  })

  -- LSP operations
  wk.add({
    { "<leader>l", group = "LSP", buffer = bufnr },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition", buffer = bufnr },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References", buffer = bufnr },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Implementation", buffer = bufnr },
    { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Type definition", buffer = bufnr },
    { "<leader>ls", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "Document symbols", buffer = bufnr },
    { "<leader>lci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", desc = "Incoming calls", buffer = bufnr },
    { "<leader>lco", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", desc = "Outgoing calls", buffer = bufnr },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code action", buffer = bufnr },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format", buffer = bufnr },
    { "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename", buffer = bufnr },
  })

  -- Workspace management
  wk.add({
    { "<leader>lw", group = "Workspace", buffer = bufnr },
    { "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", desc = "Add folder", buffer = bufnr },
    { "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", desc = "Remove folder", buffer = bufnr },
    { "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "List folders", buffer = bufnr },
  })

  -- Diagnostics
  wk.add({
    { "<leader>x", group = "diagnostics", buffer = bufnr },
    { "<leader>xx", "<cmd>lua vim.diagnostic.open_float(0, {scope = 'line'})<CR>", desc = "Show diagnostic float", buffer = bufnr },
    { "<leader>xn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next diagnostic", buffer = bufnr },
    { "<leader>xp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous diagnostic", buffer = bufnr },
    { "<leader>xq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", desc = "Set location list", buffer = bufnr },
  })

  -- Keep K and Ctrl-K for traditional vim users
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true, buffer = bufnr})

  -- Keep ]q and [q for quickfix-style navigation
  vim.keymap.set("n", "]q", "<cmd>lua vim.diagnostic.goto_next()<CR>", {noremap = true, silent = true, buffer = bufnr})
  vim.keymap.set("n", "[q", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {noremap = true, silent = true, buffer = bufnr})

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

  -- Enable inlay hints if supported
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
  -- Check for Windows vs Unix
  local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
  local python_path = is_windows and "Scripts/python.exe" or "bin/python"

  for _, venv_name in ipairs(venv_names) do
    local venv_path = workspace_root .. "/" .. venv_name .. "/" .. python_path
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

require("lspconfig").prettier.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
