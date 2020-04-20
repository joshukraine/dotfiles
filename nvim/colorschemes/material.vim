" Settings for Material colorscheme
" https://github.com/haishanh/night-owl.vim

set background=dark
set termguicolors

let g:material_terminal_italics = 1
let g:material_theme_style = 'default'

silent! colorscheme material

highlight CursorLine guibg=#2c3b41

highlight clear CursorColumn
highlight clear ColorColumn
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine

let g:lightline = {
    \   'colorscheme': 'material_vim',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
