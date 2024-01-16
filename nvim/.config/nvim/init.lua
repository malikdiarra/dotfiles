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

-- diff mode keybinds
if vim.diff then
  vim.opt.diffopt = vim.opt.diffopt + 'vertical'
  vim.keymap.set('n', '<leader>1', ':diffget 1<CR>', {noremap = true, silent = true})
  vim.keymap.set('n', '<leader>2', ':diffget 2<CR>', {noremap = true, silent = true})
  vim.keymap.set('n', '<leader>3', ':diffget 3<CR>', {noremap = true, silent = true})

  vim.keymap.set('n', '<leader>u', ':diffupdate<CR>', {noremap = true, silent = true})

  -- exit with error
  vim.keymap.set('n', '<leader>q', ':cq<CR>', {noremap = true, silent = true})

  -- navigate diffs
  vim.keymap.set('n', '<leader>i', ':cp<CR>', {noremap = true, silent = true})
  vim.keymap.set('n', '<leader>k', ':cn<CR>', {noremap = true, silent = true})
end
