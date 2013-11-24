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

  attr_reader :arguments, :usage, :name

  def initialize(options = {})
    @name = 'release'
    super @name, 'Build gem from a gemspec and push to rubygems.org', default_options_with(options)

    option :tag,   '-t', 'Create a git tag and push --tags to origin'
    option :quiet, '-q', 'Do not output status messages'
    option :key,   '-k', 'Use the given API key from ~/.gem/credentials'
    option :host,  '-h', 'Push to a gemcutter-compatible host other than rubygems.org'

    @arguments = "gemspec - optional gemspec file name, will use the first *.gemspec if not specified"
    @usage = "#{program_name} [gemspec]"
  end

  def execute
    tasks = [:build, :push, :cleanup]
    tasks.push(:tag) if options[:tag]

    in_gemspec_dirs do
      tasks.each do |task|
        run_cmd(task)
      end
    end

    success
  end

  protected

    def build
      BuildCommand.new.invoke(gemspec_filename)
      true
    end

    def push
      args = []
      [:key, :host].each do |option|
        args += ["--#{option}", options[option]] unless options[option] == ''
      end
      args += "--quiet" if quiet?

      PushCommand.new.invoke(gem_filename, *args)
      true
    end

    def cleanup
      say "Deleting left over gem file #{gem_filename}" unless quiet?
      system("rm #{gem_filename}")
    end

    def tag
      TagCommand.new(:quiet => quiet?, :quiet_success => true).invoke
      true
    end
end
