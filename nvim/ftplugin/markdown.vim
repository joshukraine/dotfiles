setlocal spell spelllang=en_us
set complete+=kspell

" WARNING: The conceallevel setting may be overridden by the indentLine plugin.
" To disable in a Markdown file, run :IndentLinesToggle
" https://github.com/Yggdroot/indentLine#customization
set conceallevel=0

" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
setlocal wrap linebreak nolist textwidth=0 wrapmargin=0

highlight htmlItalic cterm=italic gui=italic
highlight htmlBold cterm=bold gui=bold

" en and em dashes (https://www.w3schools.com/charsets/ref_utf_punctuation.asp)
" inoremap <buffer> --<space> –
" inoremap <buffer> ---<space> —

" arrows (https://www.w3schools.com/charsets/ref_utf_arrows.asp)
" inoremap <buffer> --><space> →
" inoremap <buffer> <--<space> ←
