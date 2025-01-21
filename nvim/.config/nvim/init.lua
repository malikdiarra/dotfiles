local vimrc = vim.fn.stdpath('config') .. '/vimrc.vim'

require('config.lazy')
wk = require("which-key")

vim.g.mapleader = ","

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
      { "<leader>d1", ":diffget 1<cr>", desc = "Get from left" },
      { "<leader>d2", ":diffget 3<cr>", desc = "Get from right" },
      { "<leader>d3", ":diffget 2<cr>", desc = "Get from middle" },
      { "<leader>di", ":cp<cr>", desc = "Previous" },
      { "<leader>dk", ":cn<cr>", desc = "Next" },
      { "<leader>dq", ":cq<cr>", desc = "Quit" },
      { "<leader>du", ":diffupdate<cr>", desc = "Update" },
    })
end

require("plugins.lsp")
