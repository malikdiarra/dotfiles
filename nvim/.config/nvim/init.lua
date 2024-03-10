local vimrc = vim.fn.stdpath('config') .. '/vimrc.vim'

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {}
    end
  }
end)
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

wk.register({
  f = {
    name = "telescope", -- optional group name
    j = { "<cmd>Telescope git_files<cr>", "Git File" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    h = { "<cmd>Telescope help_tags<cr>", "Help tags" }
  },
}, { prefix = "<leader>" })

-- diff mode keybinds
if vim.diff then
  vim.opt.diffopt = vim.opt.diffopt + 'vertical'
  wk.register({
    d = {
      name = "diff", -- optional group name
      [1] = { ":diffget 1<cr>", "Get from left" },
      [2] = { ":diffget 2<cr>", "Get from middle" },
      [3] = { ":diffget 3<cr>", "Get from right" },
      u = { ":diffupdate<cr>", "Update" },
      q = { ":cq<cr>", "Quit" },
      i = { ":cp<cr>", "Previous" },
      k = { ":cn<cr>", "Next" }
    },
  }, { prefix = "<leader>" })
end
