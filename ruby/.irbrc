# https://github.com/amazing-print/amazing_print#irb-integration
if defined?(AmazingPrint)
  require "amazing_print"
  AmazingPrint.irb!
end

# https://github.com/skatkov/irb-theme-nord
# Reline must exist before the theme file is evaluated (the gem assumes it).
require "reline"
require "irb/theme/nord/nord"

# vim: set filetype=ruby:
