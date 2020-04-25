" Settings for Tender colorscheme
" https://github.com/jacoborus/tender.vim

set termguicolors
set background=dark

silent! colorscheme tender

highlight link rubyDefine Conditional
highlight link rubyClass PreProc
highlight link rubyModule PreProc
highlight jsImport cterm=italic gui=italic
highlight jsFrom cterm=italic gui=italic
highlight jsExport cterm=italic gui=italic
highlight jsxAttrib ctermfg=81 guifg=#73cef4 cterm=italic gui=italic
highlight VertSplit ctermfg=242 ctermbg=235 guifg=#666666 guibg=#282828

let g:lightline = {
    \   'colorscheme': 'tender',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
