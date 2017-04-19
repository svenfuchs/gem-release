module Gem
  module Release
    Abort = Class.new(StandardError)

    STRATEGIES = {
      git:  '`git ls-files app lib`.split("\n")',
      glob: "Dir.glob('{bin/*,lib/**/*,[A-Z]*}')"
    }
  end
end

require 'gem/release/cmds'
require 'gem/release/config'
