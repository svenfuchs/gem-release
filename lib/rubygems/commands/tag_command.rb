class Gem::Commands::TagCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  DEFAULTS = {
    :quiet => false
  }

  attr_reader :arguments, :usage

  def initialize(options = {})
    super 'tag', 'Create a git tag and push --tags to origin', DEFAULTS.merge(options)

    option :quiet, '-q', 'Do not output status messages'
  end

  def execute
    [:tag, :push].each do |task|
      run_cmd(task)
    end
  end

  protected

    def tag
      say "Creating git tag #{tag_name}" unless quiet?
      system("git tag -am 'tag #{tag_name}' #{tag_name}")
    end

    def push
      say "Pushing --tags to the origin git repository" unless quiet?
      system('git push --tags origin')
    end

    def tag_name
      "v#{gem_version}"
    end
end
