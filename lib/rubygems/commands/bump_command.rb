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
    :tag      => false,
    :release  => false,
    :quiet    => false,
    :key      => '',
    :host     => ''
  }

  def initialize(options = {})
    super 'bump', 'Bump the gem version', DEFAULTS.merge(options)

    option :version, '-v', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :commit,  '-c', 'Perform a commit after incrementing gem version'
    option :push,    '-p', 'Push to origin'
    option :tag,     '-t', 'Create a git tag and push --tags to origin'
    option :release, '-r', 'Build gem from a gemspec and push to rubygems.org'
    option :quiet,   '-q', 'When releasing: Do not output status messages'
    option :key,     '-k', 'When releasing: Use the given API key from ~/.gem/credentials'
    option :host,    '-h', 'When releasing: Push to a gemcutter-compatible host other than rubygems.org'
  end

  def execute
    @new_version_number = nil

    # enforce option dependencies
    options[:push] = options[:push] || options[:tag]
    options[:commit] = options[:commit] || options[:push] || options[:release]

    in_gemspec_dirs do
      bump
    end

    if @new_version_number == nil
      say "No version files could be found, so no actions were performed." unless quiet?
    else
      commit  if options[:commit]
      push    if options[:push]
      release if options[:release]
      tag     if options[:tag]
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

    def release
      args = []
      [:key, :host].each do |option|
        args += ["--#{option}", options[option]] unless options[option] == ''
      end
      args += "--quiet" if quiet?

      ReleaseCommand.new.invoke(*args)
    end

    def tag
      TagCommand.new.invoke
    end
end
