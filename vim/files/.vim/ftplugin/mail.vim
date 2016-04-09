if has("unix") || has("win32unix")
    setlocal spell spelllang=fr,en
endif

setlocal textwidth=78

iab qt      quant
iab qd      quand
iab qq      quelque
iab qqs     quelques

noremap <F6> :set spell!<cr>:set spell?<cr>
