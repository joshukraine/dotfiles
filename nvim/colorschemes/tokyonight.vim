" Settings for Tokyo Night colorscheme
" https://github.com/folke/tokyonight.nvim

set termguicolors
set background=dark

" silent! colorscheme tokyonight
" silent! colorscheme tokyonight-night
" silent! colorscheme tokyonight-storm
" silent! colorscheme tokyonight-day
silent! colorscheme tokyonight-moon

let g:lightline = {
    \   'colorscheme': 'tokyonight',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }
