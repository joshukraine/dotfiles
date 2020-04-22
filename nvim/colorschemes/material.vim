" Settings for Material colorscheme
" https://github.com/haishanh/night-owl.vim

set termguicolors
set background=dark

let g:material_terminal_italics = 1
let g:material_theme_style = 'default'

silent! colorscheme material

highlight CursorLine guibg=#2c3b41

highlight clear CursorColumn
highlight clear ColorColumn
highlight link CursorColumn CursorLine
highlight link ColorColumn CursorLine

highlight clear Visual
highlight Visual ctermbg=242 guibg=#37474f

let g:lightline = {
    \   'colorscheme': 'material_vim',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
