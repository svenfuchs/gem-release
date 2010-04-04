require 'rubygems/command_manager'

Gem::CommandManager.instance.register_command :release
Gem::CommandManager.instance.register_command :tag