let b:surround_{char2nr("i")} = "% if \1 condition:\1\r% endif"
let b:surround_{char2nr("$")} = "${\r}"
let b:surround_{char2nr("f")} = "% for \1 condition:\1\r% endfor"
let b:surround_{char2nr("b")} = "<%block name='\1name\1'>\r</%block>"
inoremap <buffer> $ $()<Left>
