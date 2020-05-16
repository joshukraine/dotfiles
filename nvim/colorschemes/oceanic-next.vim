" Settings for Oceanic Next colorscheme
" https://github.com/mhartington/oceanic-next

set termguicolors
set background=dark

let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

silent! colorscheme OceanicNext

let g:indentLine_color_gui = '#253b46'

let g:lightline = {
    \   'colorscheme': 'oceanicnext',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
