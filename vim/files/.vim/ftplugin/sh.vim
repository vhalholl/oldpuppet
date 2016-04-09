if has("unix") || has("win32unix")
    setlocal nospell spelllang=en
endif

execute "map <buffer> ".g:frun." :w<CR>:Shell /bin/bash % <CR><CR>"
execute "map <buffer> ".g:fdebug." :w<CR>:Shell /usr/bin/bashdb % <CR><CR>"

