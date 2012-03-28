require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'
require 'rubygems/commands/tag_command'

class Gem::Commands::ReleaseCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  DEFAULTS = {
    :tag   => false,
    :quiet => false,
    :key   => '',
    :host  => ''
  }

  attr_reader :arguments, :usage

  def initialize(options = {})
    super 'release', 'Build gem from a gemspec and push to rubygems.org', DEFAULTS.merge(options)

    option :tag,   '-t', 'Create a git tag and push --tags to origin'
    option :quiet, '-q', 'Do not output status messages'
    option :key,   '-k', 'Use the given API key from ~/.gem/credentials'
    option :host,  '-h', 'Push to a gemcutter-compatible host other than rubygems.org'

    @arguments = "gemspec - optional gemspec file name, will use the first *.gemspec if not specified"
    @usage = "#{program_name} [gemspec]"
  end

  def execute
    tag if options[:tag]

    in_gemspec_dirs do
      build
      push
      remove
    end

    say "All is good, thanks my friend.\n"
  end

  protected

    def build
      BuildCommand.new.invoke(gemspec_filename)
    end

    def push
      args = []
      [:key, :host].each do |option|
        args += ["--#{option}", options[option]] unless options[option] == ''
      end
      args += "--quiet" if quiet?

      PushCommand.new.invoke(gem_filename, *args)
    end

    def remove
      say "Deleting left over gem file #{gem_filename}" unless quiet?
      `rm #{gem_filename}`
    end

    def tag
      TagCommand.new(:quiet => quiet?).invoke
    end
end
