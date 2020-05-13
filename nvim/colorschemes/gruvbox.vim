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

highlight link CocWarningSign GruvboxYellowSign
highlight link CocInfoSign GruvboxBlueSign
highlight link CocHintSign GruvboxOrange

highlight link CocWarningFloat GruvboxYellow
highlight link CocInfoFloat GruvboxBlue
highlight link CocHintFloat GruvboxOrange

highlight link CocDiagnosticsWarning GruvboxYellow
highlight link CocDiagnosticsInfo GruvboxBlue
highlight link CocDiagnosticsHint GruvboxOrange

highlight link CocDiagnosticsWarning GruvboxYellow
highlight link CocDiagnosticsInfo GruvboxBlue
highlight link CocDiagnosticsHint GruvboxOrange

highlight CocWarningHighlight cterm=undercurl gui=undercurl guisp=#fabd2f
highlight CocInfoHighlight cterm=undercurl gui=undercurl guisp=#83a598
highlight CocHintHighlight cterm=undercurl gui=undercurl guisp=#fe8019

let g:indentLine_color_gui = '#3c3836'

let g:lightline = {
    \   'colorscheme': 'gruvbox',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
