require_relative '../../gem/release/support/gem_command'
require_relative '../../gem/release/cmds/tag'

class Gem::Commands::TagCommand < Gem::Command
  include Gem::Release::GemCommand
  self.cmd = :tag
end
