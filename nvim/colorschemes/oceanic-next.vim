" Settings for Oceanic Next colorscheme
" https://github.com/mhartington/oceanic-next

set termguicolors
set background=dark

let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

silent! colorscheme OceanicNext

highlight clear CursorLine
highlight clear CursorLineNr
highlight clear CursorColumn
highlight clear ColorColumn
highlight clear VertSplit

highlight Include cterm=italic gui=italic
highlight htmlArg cterm=italic gui=italic
highlight jsxCloseString ctermfg=243 guifg=#65737e

highlight VertSplit guifg=#314e5d
highlight CursorLine guibg=#20343e

highlight link jsxAttrib htmlArg
highlight link CursorLineNr CursorLine
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine

highlight CocErrorSign ctermfg=203 guifg=#ec5f67
highlight CocWarningSign ctermfg=221 guifg=#fac863
highlight CocInfoSign ctermfg=68 guifg=#6699cc
highlight CocHintSign ctermfg=209 guifg=#f99157

let g:indentLine_color_gui = '#253b46'

let g:lightline = {
    \   'colorscheme': 'oceanicnext',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
