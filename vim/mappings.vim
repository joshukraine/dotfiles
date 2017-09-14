let mapleader = "\<Space>"

" Misc
map <leader>ev :tabe ~/.vimrc<CR>
map <leader>r :source ~/.vimrc<CR>:AirlineRefresh<CR>
map <leader>q :q<CR>
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>ra :%s/
map <leader>p :set paste<CR>""p:set nopaste<CR> " Fix indentation on paste
map <leader>i mmgg=G`m<CR> " For indenting code
map <leader>h :nohl<CR> " Clear highlights
map <leader>s :%s/\s\+$//e<CR> " Manually clear trailing whitespace
inoremap <C-[> <Esc>:w<CR> " Return to normal mode faster + write file
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <leader><leader> <c-^> " Switch between the last two files
map <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T
map Q <Nop> " Disable Ex mode
map K <Nop> " Disable K looking stuff up

" Expand active file directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Delete all lines beginning with '#' regardless of leading space.
map <leader>d :g/^\s*#.*/d<CR>:nohl<CR>

" Run 'git blame' on a selection of code
vmap <leader>gb :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" zoom a vim pane like in tmux
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
" zoom back out
nnoremap <leader>= :wincmd =<cr>

" Write files as sudo
cmap w!! w !sudo tee >/dev/null %
