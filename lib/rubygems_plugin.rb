require 'rubygems/command_manager'
require 'gem_release'

Gem::CommandManager.instance.register_command :gemspec
Gem::CommandManager.instance.register_command :init
Gem::CommandManager.instance.register_command :release
Gem::CommandManager.instance.register_command :tag