"" PHP

if has("unix") || has("win32unix")
    setlocal nospell spelllang=en
endif

"list spécials chars
setlocal list
setlocal listchars=tab:>.,trail:. ",extends:#,nbsp:.

source ~/.vim/plugin/word_complete.vim
setlocal complete=.,w,b,u,t,i,k~/.vim/syntax/php.api
call DoWordComplete()

execute "nmap ".g:frun." :w<CR>:Shell /usr/bin/php -f % <CR><CR>"
execute "nmap ".g:fdebug." :w<CR>:Shell /usr/bin/php -l % <CR><CR>"
