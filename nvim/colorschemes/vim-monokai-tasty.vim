" Settings for vim-monokai-tasty colorscheme
" https://github.com/patstockwell/vim-monokai-tasty

set termguicolors
set background=dark

let g:vim_monokai_tasty_italic = 1

silent! colorscheme vim-monokai-tasty

let g:lightline = {
    \   'colorscheme': 'monokai_tasty',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
