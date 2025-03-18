if (exists("b:did_ftplugin"))
  finish
endif

let b:did_ftplugin = 1
" Move lines up and down
nnoremap <buffer> K kmzjddkP`zk
nnoremap <buffer> J jmzkddp`zj
"
nnoremap T gg}k
"
" Change action on the current line
nnoremap s mz^cwsquash<esc>`z
nnoremap f mz^cwfixup<esc>`z
nnoremap p mz^cwpick<esc>`z
nnoremap e mz^cwedit<esc>`z
nnoremap r mz^cwreword<esc>`z
nnoremap b mz^cwbreak<esc>`z
" from https://vi.stackexchange.com/questions/24537/map-d-to-a-function-without-waiting
nnoremap <buffer> <nowait> d mz^cwdrop<esc>`z
" nnoremap x mz^cwexec<esc>`z

"" Deactivate default rebase keybinds
let g:no_gitrebase_maps = 1
