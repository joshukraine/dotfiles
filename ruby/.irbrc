# https://github.com/amazing-print/amazing_print#irb-integration
if defined?(AmazingPrint)
  require "amazing_print"
  AmazingPrint.irb!
end

# https://github.com/vitallium/irb-theme-tokyonight
require "irb/theme/tokyonight/storm"

# vim: set filetype=ruby:
