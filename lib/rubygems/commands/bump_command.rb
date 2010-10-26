require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage

  OPTIONS = { :version => 'patch', :push => false, :tag => false, :release => false }

  def initialize
    super 'bump', 'Bump the gem version', OPTIONS

    option :version, '-v', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :push,    '-p', 'Push to origin'
    option :tag,     '-t', 'Create a git tag and push --tags to origin'
    option :release, '-r', 'Build gem from a gemspec and push to rubygems.org'
  end

  def execute
    bump
    commit
    push    if options[:push] || options[:tag]
    release if options[:release]
    tag     if options[:tag]
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

    def release
      ReleaseCommand.new.invoke
    end

    def tag
      TagCommand.new.invoke
    end

    def version
      @version ||= VersionFile.new(:target => options[:version])
    end
end
