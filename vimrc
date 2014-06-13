" Pathogen

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Basic configuration

set hlsearch

set bs=2

set showcmd

set hidden

syntax on

filetype plugin indent on 

set sts=2 sw=2 ts=2

set expandtab

set cursorline
set number

" autocompletion menus
"
set wildmode=longest,list
set wildmenu
" Color

":set t_Co=256
:set background=dark

:hi Cursorline cterm=NONE ctermbg=darkgrey guibg=darkgrey

"  setting leader to comma

let mapleader=","

" opening file in current file directory

cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%

" Custom autocommands

augroup vimrcEx
  autocmd!
  autocmd FileType text setlocal textwidth=78
  
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

  autocmd FileType python set sw=4 sts=4 et
  
  autocmd BufRead *.md set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.md setfiletype mkd
augroup END

" Deactivating arrown keys
map <Left> :echo "No!"<cr>
map <Down> :echo "No!"<cr>
map <Right> :echo "No!"<cr>
map <Up> :echo "No!"<cr>
map <leader>j <C-W>j
map <leader>h <C-W>h
map <leader>k <C-W>k
map <leader>l <C-W>l


" Custom function

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" Testing commands
map <leader>t :call RunTestFile()<cr>

function! RunTestFile(...)
    let f = expand("%:p:r")
    let in_test_file = match(f, 'test$') != 1
    if in_test_file
        let test_file = expand("%")
    else
        let test_file = f . '_test.py'
    endif
    exec '!nosetests ' . test_file
endfunction


