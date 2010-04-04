require 'gem_release/helpers'

class Gem::Commands::TagCommand < Gem::Command
  include GemRelease::Helpers

  attr_reader :arguments, :usage

  def initialize
    super 'tag', 'Create a git tag and push --tags to origin'
    @arguments = '' 
    @usage = "#{program_name}"
  end

  def execute
    tag
    push
  end
  
  protected

    def tag
      say "Creating git tag #{tag_name}"
      `git tag -am 'tag #{tag_name}' #{tag_name}`
    end

    def push
      say "Pushing --tags to origin git repository"
      `git push --tags origin`
    end
    
    def tag_name
      "v#{gem_version}"
    end
end