# https://github.com/amazing-print/amazing_print#irb-integration
if defined?(AmazingPrint)
  require "amazing_print"
  AmazingPrint.irb!
end

# https://github.com/vitallium/irb-theme-tokyonight
if defined?(Irb::Theme::Tokyonight)
  require "irb/theme/tokyonight/storm"
end

# vim: set filetype=ruby:
