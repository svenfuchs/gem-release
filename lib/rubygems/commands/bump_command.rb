require 'gem_release'
require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage

  DEFAULTS = {
    :version  => 'patch',
    :push     => false,
    :tag      => false,
    :release  => false,
    :commit   => true,
    :quiet    => false
  }

  def initialize(options = {})
    super 'bump', 'Bump the gem version', DEFAULTS.merge(options)

    option :version, '-v', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :commit,  '-c', 'Perform a commit after incrementing gem version'
    option :push,    '-p', 'Push to origin'
    option :tag,     '-t', 'Create a git tag and push --tags to origin'
    option :release, '-r', 'Build gem from a gemspec and push to rubygems.org'
    option :quiet,   '-q', 'Do not output status messages'
  end

  def execute
    in_gemspec_dirs do
      bump
    end

    @version = nil # UGH
    commit  if options[:commit]
    push    if options[:push] || options[:tag]
    release if options[:release]
    tag     if options[:tag]
  end

  protected

    def bump
      if File.exist?(version.filename)
        say "Bumping #{gem_name} from #{version.old_number} to version #{version.new_number}" unless quiet?
        version.bump!
        `git add #{version.filename}` if options[:commit]
      else
        say "Ignoring #{gem_name}. Version file #{version.filename} not found" unless quiet?
      end
    end

    def commit
      say "Creating commit" unless quiet?
      `git commit -m "Bump to #{version.new_number}"`
    end

    def push
      say "Pushing to origin" unless quiet?
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
