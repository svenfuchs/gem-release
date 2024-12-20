require_relative '../../gem/release/support/gem_command'
require_relative '../../gem/release/cmds/bootstrap'

class Gem::Commands::BootstrapCommand < Gem::Command
  include Gem::Release::GemCommand
  self.cmd = :bootstrap
end
