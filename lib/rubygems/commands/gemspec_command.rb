class Gem::Commands::GemspecCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  OPTIONS = { :strategy => 'git' }

  attr_reader :arguments, :usage

  def initialize
    super 'bootstrap', 'Bootstrap a new gem source repository', OPTIONS

    option :strategy, '-f', 'Strategy for collecting files [glob|git] in .gemspec'
  end

  def execute
    gemspec = Gemspec.new(options)
    if gemspec.exists?
      say "Skipping #{gemspec.filename}: already exists"
    else
      say "Creating #{gemspec.filename}"
      gemspec.write
    end
  end
end
