require_relative '../../gem/release/support/gem_command'
require_relative '../../gem/release/cmds/bump'

class Gem::Commands::BumpCommand < Gem::Command
  include Gem::Release::GemCommand
  self.cmd = :bump
end
