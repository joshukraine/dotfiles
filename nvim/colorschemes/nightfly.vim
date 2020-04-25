" Settings for Nightfly colorscheme
" https://github.com/bluz71/vim-nightfly-guicolors

set termguicolors
set background=dark

" let g:nightflyCursorColor = 1 " Default is 0
" let g:nightflyTerminalColors = 0 " Default is 1
let g:nightflyUnderlineMatchParen = 1 " Default is 0
" let g:nightflyUndercurls = 0 " Default is 1

silent! colorscheme nightfly

let g:lightline = {
    \   'colorscheme': 'nightfly',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
