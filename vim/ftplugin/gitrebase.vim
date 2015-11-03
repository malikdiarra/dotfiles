" Move lines up and down
nnoremap <buffer> K kmzjddkP`zk
nnoremap <buffer> J jmzkddp`zj

" Change action on the current line
nnoremap s mz^cwsquash<esc>`z
nnoremap f mz^cwfixup<esc>`z
nnoremap p mz^cwpick<esc>`z
nnoremap e mz^cwedit<esc>`z
nnoremap r mz^cwreword<esc>`z

" Deactivate default rebase keybinds (defined in
" /usr/share/vim/vim74/ftplugin/gitrebase.vim)
let g:no_gitrebase_maps = 1
