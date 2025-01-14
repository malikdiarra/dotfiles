call plug#begin()
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'github/copilot.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'mattn/emmet-vim'
  Plug 'rebelot/kanagawa.nvim'
  Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'fatih/vim-go'
call plug#end()

" Custom autocommands {{{
augroup vimrcEx
  autocmd!

  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

  autocmd FileType python set sw=4 sts=4 et
  autocmd FileType javascript set sw=2 sts=2 et
  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType go setlocal noet ts=4 sw=4 sts=4
  autocmd FileType gitconfig setlocal noet ts=4 sw=4 sts=4

  autocmd BufRead *.md set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.md setfiletype mkd
  autocmd BufRead *.gradle setfiletype groovy
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  " remove all trailing whitespaces before saving
  autocmd BufWritePre * :%s/\s\+$//e

  autocmd FileType go autocmd BufWritePre <buffer> GoFmt
augroup END

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" Resize splits when window is resized
au VimResized * :wincmd =

" Cursor line is only shown in normal mode / current window
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END
"}}}

" Status Line ----------------------------------------------{{{
set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
" }}}

" General Shortcuts {{{
" opening file in current file directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ee :edit %%
map <leader>ev :edit $MYVIMRC<cr>
map <leader>et :edit ~/journal.md<cr>


" Deactivating arrown keys
map <Left> :echo "No!"<cr>
map <Down> :echo "No!"<cr>
map <Right> :echo "No!"<cr>
map <Up> :echo "No!"<cr>

" Mapping ,<motion> to window change action
map <leader>j <C-W>j
map <leader>h <C-W>h
map <leader>k <C-W>k
map <leader>l <C-W>l

inoremap <c-u> <esc>bgUwgi

" Save
nnoremap s :w<cr>
nnoremap :w<cr> :echo "No!"<cr>
nnoremap :wq<cr> :echo "No! use ZZ"<cr>

" Keep cursor at the same place when joining lines
nnoremap J mzJ`z

" Split line
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Clipboard yank and paste
vnoremap <leader>y "*y
nnoremap <leader>y "*y
nnoremap <leader>p "*p
nnoremap <leader>P "*P

nmap gV `[v`]

" Correccting up and down navigation
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Move visual blocks
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Insert blank line
nnoremap <cr> o<esc>
nnoremap <s-cr> O<esc>

" }}}

"{{{ Color
set background=dark
hi Cursorline cterm=NONE ctermbg=darkgrey guibg=darkgrey

" Highlighting trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\(\s\+$\)\|\(\($\n\s*\)\+\%$\)/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ColorColumn ctermbg=darkgrey guibg=#2c2d27
let &colorcolumn="80,".join(range(120,999),",")
set termguicolors
colorschem kanagawa
"}}}

nnoremap <bs> <c-^>
