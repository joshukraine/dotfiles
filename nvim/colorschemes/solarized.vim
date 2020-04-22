" Settings for Solarized colorscheme
" https://github.com/icymind/NeoSolarized

set termguicolors
set background=dark

let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 1

silent! colorscheme NeoSolarized " https://github.com/altercation/vim-colors-solarized#the-values

let g:lightline = {
    \   'colorscheme': 'solarized',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
