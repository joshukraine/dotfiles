setlocal spell spelllang=en_us
set complete+=kspell

set conceallevel=2

" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
setlocal wrap linebreak nolist textwidth=0 wrapmargin=0

highlight htmlItalic cterm=italic gui=italic
highlight htmlBold cterm=bold gui=bold

" https://github.com/Yggdroot/indentLine#customization
let g:indentLine_enabled = 0

" en and em dashes (https://www.w3schools.com/charsets/ref_utf_punctuation.asp)
" inoremap <buffer> --<space> –
" inoremap <buffer> ---<space> —

" arrows (https://www.w3schools.com/charsets/ref_utf_arrows.asp)
" inoremap <buffer> --><space> →
" inoremap <buffer> <--<space> ←
