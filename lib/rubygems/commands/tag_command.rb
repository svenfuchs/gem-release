class Gem::Commands::TagCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  DEFAULTS = {
    :quiet       => false,
    :destination => "origin"
  }

  attr_reader :arguments, :usage, :name

  def initialize(options = {})
    @name = 'tag'
    super @name, 'Create a git tag and push it to the destination', default_options_with(options)

    option :quiet,       '-q', 'Do not output status messages'
    option :destination, '-d', 'Git destination'
  end

  def execute
    [:tag, :push].each do |task|
      run_cmd(task)
    end

    success
  end

  protected

    def tag
      say "Creating git tag #{tag_name}" unless quiet?
      system("git tag -am \"tag #{tag_name}\" #{tag_name}")
    end

    def push
      unless options[:push_tags_only]
        say "Pushing to the origin git repository" unless quiet?
        return false unless system("git push #{options[:destination]}")
      end

      say "Pushing #{tag_name} to the #{options[:destination]} repository" unless quiet?
      system("git push #{options[:destination]} #{tag_name}")
    end

    def tag_name
      "v#{gem_version}"
    end
end
