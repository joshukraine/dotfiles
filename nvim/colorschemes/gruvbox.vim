" Settings for Gruvbox colorscheme
" https://github.com/morhetz/gruvbox

set termguicolors
set background=dark

let g:gruvbox_sign_column = 'bg0'

silent! colorscheme gruvbox

highlight Include ctermfg=108 guifg=#8ec07c cterm=italic gui=italic
highlight htmlArg ctermfg=214 guifg=#fabd2f cterm=italic gui=italic

highlight link jsxCloseString GruvboxGray
highlight link jsxAttrib htmlArg
highlight link NERDTreeFlags GruvboxBlue
highlight link GitGutterChange GruvboxYellow

let g:lightline = {
    \   'colorscheme': 'gruvbox',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
