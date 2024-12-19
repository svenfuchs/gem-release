require_relative 'gem/release'
require 'rubygems/command_manager'

require_relative 'rubygems/commands/bootstrap_command'
require_relative 'rubygems/commands/bump_command'
require_relative 'rubygems/commands/gemspec_command'
require_relative 'rubygems/commands/release_command'
require_relative 'rubygems/commands/tag_command'

Gem::CommandManager.instance.register_command :bootstrap
Gem::CommandManager.instance.register_command :bump
Gem::CommandManager.instance.register_command :gemspec
Gem::CommandManager.instance.register_command :release
Gem::CommandManager.instance.register_command :tag
