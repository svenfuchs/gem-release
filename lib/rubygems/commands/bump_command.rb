require 'gem_release'
require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage

  DEFAULTS = {
    :version  => 'patch',
    :commit   => true,
    :push     => false,
    :quiet    => false
  }

  def initialize(options = {})
    super 'bump', 'Bump the gem version', DEFAULTS.merge(options)

    option :version, '-v', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :commit,  '-c', 'Perform a commit after incrementing gem version'
    option :push,    '-p', 'Push to origin'
    option :quiet,   '-q', 'Do not output status messages'
  end

  def execute
    @new_version_number = nil

    # enforce option dependencies
    options[:commit] = options[:commit] || options[:push]

    in_gemspec_dirs do
      bump
    end

    if @new_version_number == nil
      say "No version files could be found, so no actions were performed." unless quiet?
    else
      commit  if options[:commit]
      push    if options[:push]
    end
  end

  protected

    def bump
      version = VersionFile.new(:target => (@new_version_number || options[:version]))
      if File.exist?(version.filename)
        @new_version_number ||= version.new_number
        say "Bumping #{gem_name} from #{version.old_number} to version #{version.new_number}" unless quiet?
        version.bump!
        `git add #{version.filename}` if options[:commit]
      else
        say "Ignoring #{gem_name}. Version file #{version.filename} not found" unless quiet?
      end
    end

    def commit
      say "Creating commit" unless quiet?
      `git commit -m "Bump to #{@new_version_number}"`
    end

    def push
      say "Pushing to origin" unless quiet?
      `git push`
    end
end
