"let g:last_relative_dir = ''
"nnoremap \1 :call RelatedFile ("models.py")<cr>
"nnoremap \2 :call RelatedFile ("views.py")<cr>
"nnoremap \3 :call RelatedFile ("urls.py")<cr>
"nnoremap \4 :call RelatedFile ("admin.py")<cr>
"nnoremap \5 :call RelatedFile ("tests.py")<cr>
"nnoremap \6 :call RelatedFile ( "templates/" )<cr>
"nnoremap \7 :call RelatedFile ( "templatetags/" )<cr>
"nnoremap \8 :call RelatedFile ( "management/" )<cr>
"nnoremap \0 :e settings.py<cr>
"nnoremap \9 :e urls.py<cr>
"
"fun! RelatedFile(file)
"  if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
"    exec "edit %:h/" . a:file
"    let g:last_relative_dir = expand("%:h") . '/'
"    return ''
"  endif
"  if g:last_relative_dir != ''
"    exec "edit " . g:last_relative_dir . a:file
"    return ''
"  endif
"  echo "Cant determine where relative file is : " . a:file
"  return ''
"endfun
"
"fun SetAppDir()
"  if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
"    let g:last_relative_dir = expand("%:h") . '/'
"    return ''
"  endif
"endfun
"autocmd BufEnter *.py call SetAppDir()
"
" additional surrounds
augroup htmlDjangoSurround
  autocmd Filetype htmldjango let b:surround_{char2nr("v")} = "{{ \r }}"
  autocmd Filetype htmldjango let b:surround_{char2nr("{")} = "{{ \r }}"
  autocmd Filetype htmldjango let b:surround_{char2nr("%")} = "{% \r %}"
  autocmd Filetype htmldjango let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
  autocmd Filetype htmldjango let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
  autocmd Filetype htmldjango let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
  autocmd Filetype htmldjango let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
  autocmd Filetype htmldjango let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
augroup END
