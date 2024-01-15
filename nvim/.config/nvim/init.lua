local vimrc = vim.fn.stdpath('config') .. '/vimrc.vim'

vim.g.mapleader = ","
vim.cmd.source(vimrc)
