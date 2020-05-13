" Settings for Night Owl colorscheme
" https://github.com/haishanh/night-owl.vim

set termguicolors
set background=dark

silent! colorscheme night-owl

highlight VertSplit ctermfg=243 guifg=#1d3b53

highlight CocWarningSign ctermfg=11 guifg=#fab005
highlight CocInfoSign    ctermfg=12 guifg=#15aabf
highlight CocHintSign    ctermfg=130 guifg=#ff922b

highlight clear CursorColumn
highlight clear ColorColumn
highlight clear LineNr

highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine
highlight link LineNr VertSplit

let g:indentLine_color_gui = '#1d3b53'

let g:lightline = {
    \   'colorscheme': 'nightowl',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
