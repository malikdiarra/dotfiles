local vimrc = vim.fn.stdpath('config') .. '/vimrc.vim'

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

vim.cmd.source(vimrc)
