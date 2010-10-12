require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'
require 'rubygems/commands/tag_command'

class Gem::Commands::ReleaseCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  OPTIONS = { :tag => false }

  attr_reader :arguments, :usage

  def initialize
    super 'release', 'Build gem from a gemspec and push to rubygems.org'
    option :tag, '-t', 'Create a git tag and push --tags to origin'
    @arguments = "gemspec - optional gemspec file name, will use the first *.gemspec if not specified"
    @usage = "#{program_name} [gemspec]"
  end

  def execute
    build
    push
    remove
    tag if options[:tag]
    say "All is good, thanks buddy.\n"
  end

  protected

    def build
      BuildCommand.new.invoke(gemspec_filename)
    end

    def push
      PushCommand.new.invoke(gem_filename)
    end

    def remove
      `rm #{gem_filename}`
      say "Deleting left over gem file #{gem_filename}"
    end

    def tag
      TagCommand.new.invoke
    end
end
