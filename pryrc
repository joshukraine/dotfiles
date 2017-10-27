if defined?(PryDebugger) or defined?(PryByebug)
  Pry.commands.alias_command 'cc', 'continue'
  Pry.commands.alias_command 'ss', 'step'
  Pry.commands.alias_command 'nn', 'next'
  Pry.commands.alias_command 'ff', 'finish'
  Pry.config.prompt = Pry::SIMPLE_PROMPT
end

if defined?(AwesomePrint)
  require "awesome_print"
  AwesomePrint.pry!
end
