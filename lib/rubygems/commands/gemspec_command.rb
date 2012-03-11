class Gem::Commands::GemspecCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  DEFAULTS = {
    :strategy => 'git',
    :quiet    => false
  }

  attr_reader :arguments, :usage

  def initialize(options = {})
    super 'bootstrap', 'Bootstrap a new gem source repository', DEFAULTS.merge(options)

    option :strategy, '-f', 'Strategy for collecting files [glob|git] in .gemspec'
    option :quiet,    '-q', 'Do not output status messages'
  end

  def execute
    gemspec = GemspecTemplate.new(options)
    if gemspec.exists?
      say "Skipping #{gemspec.filename}: already exists" unless quiet?
    else
      say "Creating #{gemspec.filename}" unless quiet?
      gemspec.write
    end
  end
end
