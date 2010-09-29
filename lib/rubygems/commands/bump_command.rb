require 'core_ext/string/camelize'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  attr_reader :arguments, :usage

  OPTIONS = { :to => :patch, :push => false }

  def initialize
    super 'bump', 'Bump the gem version', OPTIONS

    option :to,   '-t', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :push, '-p', 'Push to origin (defaults to false)'
  end

  def execute
    bump
    commit
    push if options[:push]
  end
  
  protected

    def bump
      say "Bumping from #{version.old_number} to version #{version.new_number}"
      version.bump!
    end

    def commit
      say "Creating commit"
      `git add #{version.filename}`
      `git commit -m "Bump to #{version.new_number}"`
    end

    def push
      say "Pushing to origin"
      `git push`
    end
    
    def version
      @version ||= VersionFile.new(:target => options[:to])
    end
end