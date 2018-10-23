"Activating file window
map <F9> <Esc>:NERDTreeToggle<CR>

"Showing taglist windows
map <F8> <Esc>:TlistToggle<CR>

"Activating Django completion
map <F10> <Esc>:call SetAutoDjangoCompletion()<CR>

"Opening a definition with Rope
map <F6> <Esc>:RopeGotoDefinition<CR>

"Renaming a var with Rope
map <F7> <Esc>:RopeRename<CR>

"Showing Tasks
map <C-t> <Plug>TaskList

"Showing history
map <C-h> <Esc>:GundoToggle<CR>

"Running unit tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>

