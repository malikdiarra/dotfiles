vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require('config.lazy')
wk = require("which-key")

-- autogroups
-- Cursor line is only shown in normal mode / current window
local clineGroup = vim.api.nvim_create_augroup("cline", {clear=true})
vim.api.nvim_create_autocmd({"WinLeave", "InsertEnter"}, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = false
  end,
  group = clineGroup,
})
vim.api.nvim_create_autocmd({"WinEnter", "InsertLeave"}, {
  pattern = "*",
  callback = function()
    vim.opt.cursorline = true
  end,
  group = clineGroup,
})

local mainGroup = vim.api.nvim_create_augroup("vimrcEx", {clear=true})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.cmd [[
      if line("'\"") > 0 && line("'\"") <= line("$") |
        exe "normal! g`\"" |
      endif
      ]]
  end,
  group = mainGroup,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = true
    vim.opt_local.foldmethod = 'indent'
  end,
  group = mainGroup,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true
  end,
  group = mainGroup,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitconfig",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = false
  end,
  group = mainGroup,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.expandtab = false
  end,
  group = mainGroup,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "quickfix",
  callback = function()
    vim.cmd [[
      nnoremap <buffer> <cr> <cr>
    ]]
  end,
  group = mainGroup,
})


vim.api.nvim_create_autocmd({"VimResized"},{
  pattern = "*",
  callback = function()
    vim.cmd [[wincmd =]]
  end,
})

-- status line
require('lualine').setup()

-- highlights
vim.cmd [[set background=dark]]
vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]
vim.cmd [[match ExtraWhitespace /\(\s\+$\)\|\(\($\n\s*\)\+\%$\)/]]
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]
  end,
})

vim.opt.colorcolumn = '80,120'
vim.cmd [[highlight ColorColumn ctermbg=darkgrey guibg=#2c2d27]]
vim.cmd [[highlight Cursorline cterm=NONE ctermbg=darkgrey guibg=darkgrey]]

-- set colorscheme
vim.cmd [[colorscheme kanagawa]]

-- highlight search result and show them incrementally
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- setting the tab size and automatically expand all inserted tabs
vim.opt.bs = 'indent,eol,start'
vim.opt.sts = 2
vim.opt.sw = 2
vim.opt.ts = 2
vim.opt.showcmd = true
vim.opt.expandtab = true

-- Splitting switch window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- allowing hidden buffer
vim.opt.hidden = true

-- syntax highlighting
vim.api.nvim_command('syntax enable')

-- enabling filetype detection
vim.api.nvim_command('filetype plugin indent on')

-- autocompletion menus
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest,list'
vim.opt.wildignore = vim.opt.wildignore + '*.o,*.pyc,*.sw?'

-- Display setup
vim.opt.cursorline = true
vim.opt.number = true

-- Activate modeline: commands at the top or bottom of a file
vim.opt.modeline = true

-- Show invisible characters
vim.opt.list = true
vim.opt.listchars = 'tab:▸ ,eol:¬,trail:·,extends:❯,precedes:❮'
vim.cmd [[highlight NonText guifg=#4a4a59]]
vim.cmd [[highlight SpecialKey guifg=#4a4a59]]

-- Back up set up
vim.opt.backup = true
local backupdir = vim.fn.expand('~/.vim-tmp/backup/')
local undodir = vim.fn.expand('~/.vim-tmp/undo/')
local swapdir = vim.fn.expand('~/.vim-tmp/swap/')
vim.opt.backupdir = backupdir
vim.opt.backupskip = '/tmp/*,/private/tmp/*'
vim.opt.undodir = undodir
vim.opt.directory = swapdir

if vim.fn.isdirectory(backupdir) == 0 then
  vim.fn.mkdir(backupdir, 'p')
end
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end
if vim.fn.isdirectory(swapdir) == 0 then
  vim.fn.mkdir(swapdir, 'p')
end

vim.cmd.source(vimrc)


-- switch between buffers
wk.add({
  { "<bs>", "<c-^>" }
})

-- open files
wk.add({
  { "<leader>ev", ":edit $MYVIMRC<cr>" },
})

-- selection pasted content
wk.add({
  { "gV", "`[v`]" }
})

-- up / down navigation
wk.add({
  { "<Left>", ":echo \"No!\"<cr>" },
  { "<Right>", ":echo \"No!\"<cr>" },
  { "<Down>", ":echo \"No!\"<cr>" },
  { "<Up>", ":echo \"No!\"<cr>" },
})

wk.add({
  { "j", "gj" },
  { "k", "gk" },
  { "gj", "k" },
  { "gk", "k" },
})

-- window motions
wk.add({
  { "<leader>j", "<C-W>j" },
  { "<leader>h", "<C-W>h" },
  { "<leader>k", "<C-W>k" },
  { "<leader>l", "<C-W>l" },
})

-- yank and paste
wk.add({
  {"<leader>y", "\"*y", mode = { "v", "n" }, desc="Copy to system clipboard"},
  {"<leader>p", "\"*p", desc = "Paste to system clipboard"},
  {"<leader>P", "\"*P", desc = "Paste to system clipboard"},
})

-- save
wk.add({
  { "s", ":w<cr>" },
  { ":w", ":echo \"No!\"<cr>" },
  { ":wq", ":echo \"Use ZZ\"<cr>" },
})

-- move visual block
wk.add({
  { "J", ":m '>+1<CR>gv=gv", mode = "v" },
  { "K", ":m '>-2<CR>gv=gv", mode = "v" },
})

-- joining and splitting lines
wk.add({
  { "J", "mzJ`z" },
  { "S", "i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w " },
})

-- insert blank lines
wk.add({
  { "<cr>", "o<esc>" },
  { "<S-cr>", "O<esc>" }, -- this does not work outside of gvim
})

wk.add({
  { "<leader>f", group = "telescope" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
  { "<leader>fj", "<cmd>Telescope git_files<cr>", desc = "Git File" },
})

-- diff mode keybinds
if vim.diff then
  vim.opt.diffopt = vim.opt.diffopt + 'vertical'
  wk.add(
    {
      { "<leader>d", group = "diff" },
      { "<leader>du", ":diffget 1<cr>", desc = "Get from left" },
      { "<leader>di", ":diffget 3<cr>", desc = "Get from right" },
      { "<leader>do", ":diffget 2<cr>", desc = "Get from middle" },
      { "<leader>dj", ":cp<cr>", desc = "Previous" },
      { "<leader>dk", ":cn<cr>", desc = "Next" },
      { "<leader>dq", ":cq<cr>", desc = "Quit" },
      { "<leader>dh", ":diffupdate<cr>", desc = "Update" },
    })
end

require("plugins.lsp")

local cmp = require('cmp')
cmp.setup({
    snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' }
  },
})
