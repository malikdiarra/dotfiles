" Pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype on

" Basic configuration {{{

"  setting leader to comma
let mapleader=","

" highlight search result
set hlsearch

" setting the tab size and automatically expand all inserted tabs
set bs=2
set sts=2 sw=2 ts=2
set showcmd
set expandtab

" Splitting switch window
set splitbelow
set splitright

" allowing hidden buffer
set hidden

" syntax highlighting
syntax on

" enabling filetype detection
filetype plugin indent on

" autocompletion menus
set wildmode=longest,list
set wildmenu
set wildignore+=*.o,*.pyc
set wildignore+=*.sw?
"}}}

" Display setup {{{
" highlight the line of the cursor
set cursorline

" show the line on the left side of the screen
set number

"}}}

" Custom autocommands {{{
augroup vimrcEx
  autocmd!
  autocmd FileType text setlocal textwidth=78

  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

  autocmd FileType python set sw=4 sts=4 et
  autocmd FileType python setlocal foldmethod=indent

  autocmd BufRead *.md set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.md setfiletype mkd
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
map <leader>e :edit %%


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

" Keep cursor at the same place when joining lines
nnoremap J mzJ`z

nmap gV `[v`]
" }}}

"{{{ Color
:set background=dark
:hi Cursorline cterm=NONE ctermbg=darkgrey guibg=darkgrey

" Highlighting trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\(\s\+$\)\|\(\($\n\s*\)\+\%$\)/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ColorColumn ctermbg=darkgrey guibg=#2c2d27
let &colorcolumn="80,".join(range(120,999),",")
set background=dark
if has('gui_running')
  let g:solarized_termcolors=256
  colorscheme solarized
endif
"}}}

" Ctrl-P configuration {{{
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
" }}}

:source ~/.vim/django.vim
