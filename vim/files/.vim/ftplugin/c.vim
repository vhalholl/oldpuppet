if has("unix") || has("win32unix")
    setlocal nospell spelllang=en
endif

"C/C++ OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" CTAGS prérequis tags
setlocal nocp
"filetype plugin on

" Configure tags - add additional tags here or comment out not-used ones
setlocal tags+=~/.vim/tags/stl
setlocal tags+=~/.vim/tags/gl
setlocal tags+=~/.vim/tags/sdl
setlocal tags+=~/.vim/tags/qt4

" Build tags of your own project with CTRL+F12
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"noremap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
"inoremap <F12> <Esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
