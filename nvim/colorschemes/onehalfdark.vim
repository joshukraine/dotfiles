" Settings for One Half Dark colorscheme
" https://github.com/sonph/onehalf

set termguicolors
set background=dark

silent! colorscheme onehalfdark

let g:lightline = {
    \   'colorscheme': 'onehalfdark',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
