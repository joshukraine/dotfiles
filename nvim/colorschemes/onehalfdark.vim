" Settings for One Half Dark colorscheme
" https://github.com/sonph/onehalf

set termguicolors
set background=dark

silent! colorscheme onehalfdark

highlight Include cterm=italic gui=italic
highlight jsxAttrib ctermfg=180 guifg=#e5c07b cterm=italic gui=italic

let g:lightline = {
    \   'colorscheme': 'onehalfdark',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
