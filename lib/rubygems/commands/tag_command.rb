class Gem::Commands::TagCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  DEFAULTS = {
    :quiet => false,
    :sign  => false
  }

  attr_reader :arguments, :usage, :name

  def initialize(options = {})
    @name = 'tag'
    super @name, 'Create a git tag and push --tags to origin', default_options_with(options)

    option :sign, '-s',  'GPG sign the tag'
    option :quiet, '-q', 'Do not output status messages'
  end

  def execute
    [:tag, :push].each do |task|
      run_cmd(task)
    end

    success
  end

  protected

    def tag
      if options[:sign]
        say "Creating signed git tag #{tag_name}" unless quiet?
        system("git tag -m \"tag #{tag_name}\" -s #{tag_name}")
      else
        say "Creating git tag #{tag_name}" unless quiet?
        system("git tag -am \"tag #{tag_name}\" #{tag_name}")
      end
    end

    def push
      unless options[:push_tags_only]
        say "Pushing to the origin git repository" unless quiet?
        return false unless system('git push origin')
      end

      say "Pushing --tags to the origin git repository" unless quiet?
      system('git push --tags origin')
    end

    def tag_name
      "v#{gem_version}"
    end
end
