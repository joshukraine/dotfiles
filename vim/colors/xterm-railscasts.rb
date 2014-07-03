vim_colors "xterm-railscasts" do
  author "Joshua Steele"
  notes  "Port of Railscasts color scheme for terminal vim based mostly on https://github.com/ryanb/dotfiles/blob/master/vim/colors/railscasts.vim"

  reset      true
  background :dark

  # ORDER: Foreground, Background

  # Basic colors
  Normal        "E6E1DC", "222222"
  Cursor        "FFFFFF"
  CursorLine    "333435"
  LineNr        "666666"
  Visual        "5A647E"
  Directory     "A5C160"
  Error         "FFFFFF", "990000"
  MatchParen    none, "131313"
  Title         "E6E1DC"

  SignColumn    "222222"
  NonText       "383838", "252525"
  Search        "5A647E"
  VertSplit     "383838", "383838"

  Comment       "BC9458", :gui => "italic"
  link :Todo, :to => :Comment


  # Folds
  Folded        "F6F3E8", "444444", :gui => "bold"
  link :vimFold, :FoldColumn, :to => :Folded

  # Misc
  Directory     "A5C261"

  # Popup menu
  Pmenu         "F6F3E8", "444444"
  PmenuSel      "000000", "A5C261"
  PMenuSbar     "5A647E"
  PMenuThumb    "AAAAAA"

  # Strings, numbers
  String        "A5C261" # strings
  link :Number, :to => :String
  link :rubyStringDelimiter, :to => :String

  # nil, self, symbols
  Constant      "87AFFF"

  # def, end, include, load, require, alias, super, yield, lambda, proc
  Define        "D78700"
  link :Include, :to => :Define
  link :Keyword, :to => :Define
  link :Macro,   :to => :Define

  # #{foo}
  Delimiter     "519F50"

  # function name (after def)
  Function      "E8BF6A"

  # @var, @@var, $var
  Identifier    "CFCFFF"

  # case, begin, do, for, if, unless, while, until, else
  Statement     "D78700"
  link :PreCondit, :to => :Statement
  link :PreProc,   :to => :Statement

  # SomeClassName
  Type          none, none

  # has_many, respond_to, params
  railsMethod   "AF0000"

  # ERB <%= bar %>
  erubyDelimiter "FFFFFF"

  # Git
  DiffAdd       "E6E1DC", "144212"
  DiffDelete    "E6E1DC", "660000"

  # XML, HMTL
  xmlTag        "E8BF6A"
  link :xmlTagName,  :to => :xmlTag
  link :xmlEndTag,   :to => :xmlTag
  link :xmlArg,      :to => :xmlTag
  link :htmlArg,     :to => :xmlTag
  link :htmlTag,     :to => :xmlTag
  link :htmlTagName, :to => :xmlTag
  link :htmlEndTag,  :to => :xmlTag

end














