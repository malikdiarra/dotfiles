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
