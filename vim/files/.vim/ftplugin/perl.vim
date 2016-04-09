if has("unix") || has("win32unix")
    setlocal nospell spelllang=en
endif

execute "map <buffer> ".g:frun." :w<CR>:Shell /usr/bin/perl -W % <CR><CR>"
execute "map <buffer> ".g:fdebug." :w<CR>:Shell /usr/bin/perl -c % <CR><CR>"
