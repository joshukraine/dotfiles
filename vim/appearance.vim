" https://github.com/bling/vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts=1

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.crypt = '🔒'

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" For more intricate customizations, you can replace the predefined sections
" with the usual statusline syntax.
"
" Note: If you define any section variables it will replace the default values
" entirely.  If you want to disable only certain parts of a section you can try
" using variables defined in the |airline-configuration| or |airline-extensions|
" section.
" >
"   variable names                default contents
"   ----------------------------------------------------------------------------
"   let g:airline_section_a       (mode, crypt, paste, iminsert)
"   let g:airline_section_b       (hunks, branch)
"   let g:airline_section_c       (bufferline or filename)
"   let g:airline_section_gutter  (readonly, csv)
"   let g:airline_section_x       (tagbar, filetype, virtualenv)
"   let g:airline_section_y       (fileencoding, fileformat)
"   let g:airline_section_z       (percentage, line number, column number)
"   let g:airline_section_error   (ycm_error_count, syntastic, eclim)
"   let g:airline_section_warning (ycm_warning_count, whitespace)

  " here is an example of how you could replace the branch indicator with
  " the current working directory, followed by the filename.
  " let g:airline_section_b = '%{getcwd()}'
  " let g:airline_section_c = '%t%m'

let g:airline#extensions#default#section_truncate_width = {
    \ 'y': 100,
    \ }

let g:airline#extensions#default#layout = [
    \ [ 'a', 'b', 'c' ],
    \ [ 'x', 'y', 'z', 'error', 'warning' ]
    \ ]

" airline branch settings
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#branch#displayed_head_limit = 10

  " default value leaves the name unmodifed
  " let g:airline#extensions#branch#format = 0

  " to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
  " let g:airline#extensions#branch#format = 1

  " to truncate all path sections but the last one, e.g. a branch
  " 'foo/bar/baz' becomes 'f/b/baz', use
  " let g:airline#extensions#branch#format = 2

" airline hunk settings

" enable/disable showing a summary of changed hunks under source control
" let g:airline#extensions#hunks#enabled = 1

" enable/disable showing only non-zero hunks
let g:airline#extensions#hunks#non_zero_only = 1

" set hunk count symbols
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

" set background=light " light theme
set background=dark " dark theme
colorscheme solarized

highlight clear IncSearch
highlight IncSearch term=reverse cterm=reverse ctermfg=7 ctermbg=0 guifg=Black guibg=Yellow
highlight VertSplit ctermbg=NONE guibg=NONE
highlight htmlItalic cterm=italic
highlight htmlBold cterm=bold
