" https://github.com/ryanoasis/vim-devicons/wiki/Extra-Configuration

" https://github.com/ryanoasis/vim-devicons/pull/135
let g:WebDevIconsOS = 'Darwin'

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Custom Icons
" https://www.nerdfonts.com/cheat-sheet
let s:config = ''
let s:css3   = ''
let s:fish   = ''
let s:git    = ''
let s:gulp   = ''
let s:haml   = ''
let s:html5  = ''
let s:info   = ''
let s:js     = ''
let s:json   = ''
let s:jsx    = ''
let s:lock   = ''
let s:md     = ''
let s:npm    = ''
let s:rest   = 'ﬥ'
let s:ruby   = ''
let s:sass   = ''
let s:sh     = ''
let s:svg    = ''
let s:tags   = ''
let s:ts     = 'ﯤ'
let s:tsx    = ''
let s:vim    = ''
let s:vue    = '﵂'
let s:xml    = ''

" Folder icons
let s:dotfiles_folder     = ''
let s:git_folder          = ''
let s:images_folder       = ''
let s:node_modules_folder = ''

" Filetypes
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols         = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['conf']     = s:config
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css']      = s:css3
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['fish']     = s:fish
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['haml']     = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html']     = s:html5
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']       = s:js
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['json']     = s:json
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['jsx']      = s:jsx
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['lock']     = s:lock
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']       = s:md
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['plist']    = s:config
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rb']       = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['rest']     = s:rest
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ru']       = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['svg']      = s:svg
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['terminal'] = s:config
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['toml']     = s:config
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ts']       = s:ts
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tsx']      = s:tsx
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim']      = s:vim
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue']      = s:vue
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['xml']      = s:xml
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yml']      = s:config

let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols                         = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.html\.erb$']       = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.js\.erb$']         = s:js
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.scss\.erb$']       = s:sass
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Brewfile$']            = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Gemfile$']             = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Guardfile']            = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['README']               = s:info
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Rakefile']             = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['\.env']                = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['\.env\.*']             = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['\.lock\.*']            = s:lock
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['asdfrc$']              = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['babelrc$']             = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['bashrc$']              = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['browserslistrc$']      = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['default-gems']         = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['default-npm-packages'] = s:npm
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['editorconfig']         = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['eslintignore']         = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['fish\.local*']         = s:fish
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gemrc$']               = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitconfig.*']          = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitignore.*']          = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmessage']           = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmodules']           = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitsh']                = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gulpfile.js']          = s:gulp
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['hushlogin']            = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['npmrc$']               = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['pryrc$']               = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['rc\.local*']           = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['ruby-version']         = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['stylelint*']           = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['tags']                 = s:tags
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['tool-versions']        = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['yarnrc$']              = s:config
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['zshrc$']               = s:config

" Folders
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['\.git$']        = s:git_folder
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['dotfiles$']     = s:dotfiles_folder
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['images$']       = s:images_folder
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['node_modules$'] = s:node_modules_folder

" The following autocmd lines provide coloring for the icons themselves without
" coloring the file names.
" https://github.com/ryanoasis/vim-devicons/wiki/FAQ-&-Troubleshooting#how-did-you-get-color-matching-on-just-the-glyphicon-in-nerdtree

autocmd filetype nerdtree highlight config_icon ctermbg=none ctermfg=136 guifg=#af8700
autocmd filetype nerdtree highlight css_icon ctermbg=none ctermfg=39 guifg=#00afff
autocmd filetype nerdtree highlight favicon_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight fish_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight git_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight gulpfile_icon ctermbg=none ctermfg=124 guifg=#af0000
autocmd filetype nerdtree highlight haml_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight info_icon ctermbg=none ctermfg=31 guifg=#0087af
autocmd filetype nerdtree highlight js_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight json_icon ctermbg=none ctermfg=2 guifg=#859900
autocmd filetype nerdtree highlight jsx_icon ctermbg=none ctermfg=45 guifg=#00d7ff
autocmd filetype nerdtree highlight license_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight lock_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight md_icon ctermbg=none ctermfg=31 guifg=#0087af
autocmd filetype nerdtree highlight npm_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight procfile_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight rest_icon ctermbg=none ctermfg=2 guifg=#859900
autocmd filetype nerdtree highlight ruby_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight scss_icon ctermbg=none ctermfg=205 guifg=#ff5faf
autocmd filetype nerdtree highlight sh_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight svg_icon ctermbg=none ctermfg=205 guifg=#ff5faf
autocmd filetype nerdtree highlight tags_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight ts_icon ctermbg=none ctermfg=39 guifg=#00afff
autocmd filetype nerdtree highlight vim_icon ctermbg=none ctermfg=28 guifg=#008700
autocmd filetype nerdtree highlight vue_icon ctermbg=none ctermfg=29 guifg=#00875f
autocmd filetype nerdtree highlight xml_icon ctermbg=none ctermfg=136 guifg=#af8700

autocmd filetype nerdtree highlight git_add_icon ctermbg=none ctermfg=2 guifg=#859900
autocmd filetype nerdtree highlight git_mod_icon ctermbg=none ctermfg=124 guifg=#af0000
autocmd filetype nerdtree highlight git_untracked_icon ctermbg=none ctermfg=37 guifg=#00afaf

autocmd filetype nerdtree syn match config_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match css_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match favicon_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match fish_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match gulpfile_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match haml_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
autocmd filetype nerdtree syn match info_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match js_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match json_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match jsx_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match license_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match lock_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match md_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match npm_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match procfile_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match rest_icon #ﬥ# containedin=NERDTreeFile
autocmd filetype nerdtree syn match ruby_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match scss_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match sh_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match svg_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match tags_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match ts_icon #ﯤ# containedin=NERDTreeFile
autocmd filetype nerdtree syn match vim_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match vue_icon #﵂# containedin=NERDTreeFile
autocmd filetype nerdtree syn match xml_icon ## containedin=NERDTreeFile

autocmd filetype nerdtree syn match git_add_icon #✚# containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_mod_icon #✹# containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_untracked_icon ## containedin=NERDTreeFile
