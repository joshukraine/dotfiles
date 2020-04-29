" Settings for Gruvbox colorscheme
" https://github.com/morhetz/gruvbox

set termguicolors
set background=dark

let g:gruvbox_sign_column = 'bg0'

silent! colorscheme gruvbox

let g:lightline = {
    \   'colorscheme': 'gruvbox',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
