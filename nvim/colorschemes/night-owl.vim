" Settings for Night Owl colorscheme
" https://github.com/haishanh/night-owl.vim

set background=dark
set termguicolors

silent! colorscheme night-owl

highlight clear CursorColumn
highlight clear ColorColumn
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine

let g:lightline = {
    \   'colorscheme': 'nightowl',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
