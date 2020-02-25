" https://github.com/ryanoasis/vim-devicons/wiki/Extra-Configuration

" https://github.com/ryanoasis/vim-devicons/pull/135
let g:WebDevIconsOS = 'Darwin'

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Custom Icons
" https://www.nerdfonts.com/cheat-sheet
let s:css3  = ''
let s:fish  = ''
let s:git   = ''
let s:gulp  = ''
let s:haml  = ''
let s:html5 = ''
let s:js    = ''
let s:json  = ''
let s:ts    = 'ﯤ'
let s:md    = ''
let s:ruby  = ''
let s:sass  = ''
let s:svg   = ''
let s:vim   = ''
let s:vue   = '﵂'
let s:jsx   = ''
let s:tsx   = ''

" Filetypes
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols         = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css']  = s:css3
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['haml'] = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = s:html5
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']   = s:js
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['json'] = s:json
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ts']   = s:ts
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']   = s:md
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim']  = s:vim
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue']  = s:vue
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['svg']  = s:svg
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['fish'] = s:fish
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rb']   = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['jsx']   = s:jsx
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tsx']   = s:tsx

let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols                   = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitignore.*']    = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitconfig.*']    = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmodules']     = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmessage']     = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Gemfile.*']      = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Rakefile']       = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Guardfile']      = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['vimrc$']         = s:vim
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.scss\.erb$'] = s:sass
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.js\.erb$']   = s:js
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.html\.erb$'] = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gulpfile.js']    = s:gulp

" The following autocmd lines provide coloring for the icons themselves without
" coloring the file names.
" https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting#how-did-you-get-color-matching-on-just-the-glyphicon-in-nerdtree

autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight haml_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight git_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight ruby_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight css_icon ctermbg=none ctermfg=39 guifg=#00afff
autocmd filetype nerdtree highlight yml_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight md_icon ctermbg=none ctermfg=31 guifg=#0087af
autocmd filetype nerdtree highlight js_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight ts_icon ctermbg=none ctermfg=39 guifg=#00afff
autocmd filetype nerdtree highlight json_icon ctermbg=none ctermfg=2 guifg=#859900
autocmd filetype nerdtree highlight vue_icon ctermbg=none ctermfg=29 guifg=#00875f
autocmd filetype nerdtree highlight scss_icon ctermbg=none ctermfg=205 guifg=#ff5faf
autocmd filetype nerdtree highlight vim_icon ctermbg=none ctermfg=28 guifg=#008700
autocmd filetype nerdtree highlight gulpfile_icon ctermbg=none ctermfg=124 guifg=#af0000
autocmd filetype nerdtree highlight sh_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight procfile_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight fish_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight license_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight favicon_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight svg_icon ctermbg=none ctermfg=205 guifg=#ff5faf
autocmd filetype nerdtree highlight jsx_icon ctermbg=none ctermfg=45 guifg=#00d7ff

autocmd filetype nerdtree highlight git_add_icon ctermbg=none ctermfg=2 guifg=#859900
autocmd filetype nerdtree highlight git_mod_icon ctermbg=none ctermfg=124 guifg=#af0000
autocmd filetype nerdtree highlight git_untracked_icon ctermbg=none ctermfg=37 guifg=#00afaf

autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
autocmd filetype nerdtree syn match haml_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match ruby_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match css_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match yml_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match md_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match js_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match ts_icon #ﯤ# containedin=NERDTreeFile
autocmd filetype nerdtree syn match json_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match vue_icon #﵂# containedin=NERDTreeFile
autocmd filetype nerdtree syn match scss_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match vim_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match gulpfile_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match sh_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match procfile_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match fish_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match license_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match favicon_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match svg_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match jsx_icon ## containedin=NERDTreeFile

autocmd filetype nerdtree syn match git_add_icon #✚# containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_mod_icon #✹# containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_untracked_icon ## containedin=NERDTreeFile

" The following code provides an alternative solution to coloring icons. It
" colors not only the icons but also the entire filename. It should be used as a
" replace for — not in conjunction with — the above autocmd approach.
" https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting#how-did-you-get-color-matching-based-on-file-type-in-nerdtree

" NERDTrees File highlighting
" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"   exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"   exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
" endfunction

" Primary extensions
" call NERDTreeHighlightFile('css', '32', 'none', '#0087d7', '#151515')
" call NERDTreeHighlightFile('haml', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('html', '166', 'none', '#d75f00', '#151515')
" call NERDTreeHighlightFile('js', '178', 'none', '#d7af00', '#151515')
" call NERDTreeHighlightFile('json', '178', 'none', '#d7af00', '#151515')
" call NERDTreeHighlightFile('md', '31', 'none', '#0087af', '#151515')
" call NERDTreeHighlightFile('rb', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('erb', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('scss', '205', 'none', '#ff5faf', '#151515')
" call NERDTreeHighlightFile('sh', '97', 'none', '#875faf', '#151515')
" call NERDTreeHighlightFile('vim', '28', 'none', '#008700', '#151515')
" call NERDTreeHighlightFile('vue', '29', 'none', '#00875f', '#151515')
" call NERDTreeHighlightFile('yml', '195', 'none', '#d7ffff', '#151515')
" call NERDTreeHighlightFile('adoc', '197', 'none', '#ff005f', '#151515')
" call NERDTreeHighlightFile('LICENSE', '195', 'none', '#d7ffff', '#151515')
" call NERDTreeHighlightFile('conf', '195', 'none', '#d7ffff', '#151515')

" Special files (may need to come after primaries)
" call NERDTreeHighlightFile('gulpfile.js', '124', 'none', '#af0000', '#151515')
" call NERDTreeHighlightFile('vimrc', '28', 'none', '#008700', '#151515')
" call NERDTreeHighlightFile('Gemfile', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('Gemfile.lock', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('Rakefile', '160', 'none', '#d70000', '#151515')
" call NERDTreeHighlightFile('Procfile', '97', 'none', '#875faf', '#151515')
" call NERDTreeHighlightFile('.gitignore', '166', 'none', '#d75f00', '#151515')
" call NERDTreeHighlightFile('gitconfig', '166', 'none', '#d75f00', '#151515')
" call NERDTreeHighlightFile('gitignore_global', '166', 'none', '#d75f00', '#151515')
" call NERDTreeHighlightFile('gitmessage', '166', 'none', '#d75f00', '#151515')
