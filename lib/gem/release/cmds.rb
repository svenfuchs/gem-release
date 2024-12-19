require_relative 'cmds/bootstrap'
require_relative 'cmds/bump'
require_relative 'cmds/gemspec'
require_relative 'cmds/github'
require_relative 'cmds/release'
require_relative 'cmds/runner'
require_relative 'cmds/tag'

module Gem
  module Release
    module Cmds
      def self.[](cmd)
        Base[cmd]
      end
    end
  end
end
