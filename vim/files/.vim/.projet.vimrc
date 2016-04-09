".projet.vimrc
" Use Project
runtime! ~/.vim/plugin/Project.vim

" Source his own file: ~/.vimproject_mappings
"

" Cindent on projects files
autocmd BufNewFile,BufRead .vimprojects setlocal cindent

" Mapping
" \2 on project view will svn update current directory
let g:proj_run2='!svn ci %R'

" \5 on project view will commit current directory
let g:proj_run5='!svn up %R'

" Create tags with '\1' command
function! Phptags()   
    "change exclude for your project, here it's a good exclude for Copix temp and var files"
    let cmd = '!ctags -f .tags -h ".php" -R --exclude="\.svn" --exclude="./var" --exclude="./temp" --totals=yes --tag-relative=yes'
    exec cmd
    set tags=.tags
endfunction

let g:proj_run1='call Phptags()'

"to remap \1 on ,1
"nmap ,1 \1
