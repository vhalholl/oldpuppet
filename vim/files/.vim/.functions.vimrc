".functions.vimrc

"" Shell
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

"" SuperTab
function! SmartTab()
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<Tab>"
    else
        if &omnifunc != ''
            return "\<C-X>\<C-O>"
        elseif &dictionary != ''
            return "\<C-K>"
        else
            return "\<C-N>"
        endif
    endif
endfunction

"" Reminder
let g:helpDisplay = 0

function! Reminder()
    if g:helpDisplay == 0
        tabnew
        silent! topleft vertical 60 split +buffer
        setlocal nonumber
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
        file $HOME/.vim/help.txt
        silent read $HOME/.vim/help.txt
        highlight Memory ctermfg=white ctermbg=blue
        3match Memory /^.\+\ \+:/
        "bdelete
        let g:helpDisplay = 1
    else
        tabclose
        let g:helpDisplay = 0
    endif
endfunction

if !hasmapto('<Plug>Reminder')
    map <unique> <F10> <Plug>Reminder
    imap <unique> <F10> <Plug>Reminder
endif

nnoremap <unique> <silent> <script> <Plug>Reminder :call Reminder()<cr>
