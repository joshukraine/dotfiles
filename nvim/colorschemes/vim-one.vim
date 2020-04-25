" Settings for Vim One colorscheme
" https://github.com/rakr/vim-one

set termguicolors

let g:one_allow_italics = 1

silent! colorscheme one

set background=dark

let g:lightline = {
    \   'colorscheme': 'one',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
