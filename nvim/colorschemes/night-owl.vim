" Settings for Night Owl colorscheme
" https://github.com/haishanh/night-owl.vim

set background=dark
set termguicolors

silent! colorscheme night-owl

let g:lightline = { 'colorscheme': 'nightowl' }

highlight clear CursorColumn
highlight clear ColorColumn
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine
