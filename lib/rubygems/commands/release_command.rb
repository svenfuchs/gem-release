require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'
require 'rubygems/commands/tag_command'

class Gem::Commands::ReleaseCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  DEFAULTS = {
    :tag   => false,
    :quiet => false
  }

  attr_reader :arguments, :usage

  def initialize(options = {})
    super 'release', 'Build gem from a gemspec and push to rubygems.org', DEFAULTS.merge(options)

    option :tag,   '-t', 'Create a git tag and push --tags to origin'
    option :quiet, '-q', 'Do not output status messages'

    @arguments = "gemspec - optional gemspec file name, will use the first *.gemspec if not specified"
    @usage = "#{program_name} [gemspec]"
  end

  def execute
    in_gemspec_dirs do
      build
      push
      remove
    end

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
      say "Deleting left over gem file #{gem_filename}" unless quiet?
      `rm #{gem_filename}`
    end

    def tag
      TagCommand.new.invoke
    end
end
