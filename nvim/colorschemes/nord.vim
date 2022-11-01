" Settings for Nord colorscheme
" https://github.com/arcticicestudio/nord-vim

set termguicolors
set background=dark

silent! colorscheme nord

let g:indentLine_color_gui = '#4C566A'

let g:lightline = {
    \   'colorscheme': 'nord',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
