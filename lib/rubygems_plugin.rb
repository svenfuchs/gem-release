require 'rubygems/command_manager'
require 'gem_release'

Gem::CommandManager.instance.register_command :gemspec
Gem::CommandManager.instance.register_command :bootstrap
Gem::CommandManager.instance.register_command :bump
Gem::CommandManager.instance.register_command :release
Gem::CommandManager.instance.register_command :tag
