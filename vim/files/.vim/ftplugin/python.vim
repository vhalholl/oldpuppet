"" Python
if has("unix") || has("win32unix")
    setlocal nospell spelllang=en
endif

" List specials chars
setlocal list
setlocal listchars=tab:>.,trail:.,extends:#,nbsp:.

source ~/.vim/plugin/word_complete.vim
source ~/.vim/syntax/python.vim
setlocal complete+=k~/.vim/syntax/python.vim isk+=.,(

call DoWordComplete()
autocmd BufWrite *.py silent! %s/[\r \t]\+$//

execute "map <buffer> ".g:frun." :w<CR>:Shell /usr/bin/python % <CR><CR>"
execute "map <buffer> ".g:fdebug." :w<CR>:Shell /usr/bin/pylint % <CR><CR>"
