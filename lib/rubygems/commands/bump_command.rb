require 'gem_release'
require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage, :name

  DEFAULTS = {
    :version  => '',
    :commit   => true,
    :push     => false,
    :tag      => false,
    :release  => false,
    :key      => '',
    :host     => '',
    :quiet    => false
  }

  def initialize(options = {})
    @name = 'bump'
    super @name, 'Bump the gem version', default_options_with(options)

    option :version, '-v', 'Target version: next [major|minor|patch|pre|release] or a given version number [x.x.x]'
    option :commit,  '-c', 'Perform a commit after incrementing gem version'
    option :push,    '-p', 'Push to the origin git repository'
    option :tag,     '-t', 'Create a git tag and push --tags to origin'
    option :release, '-r', 'Build gem from a gemspec and push to rubygems.org'
    option :key,     '-k', 'When releasing: use the given API key from ~/.gem/credentials'
    option :host,    '-h', 'When releasing: push to a gemcutter-compatible host other than rubygems.org'
    option :quiet,   '-q', 'Do not output status messages'
  end

  def execute
    @new_version_number = nil

    tasks = [:commit, :push, :release, :tag]

    # enforce option dependencies
    options[:push] = true if options[:tag]
    options[:commit] = options[:commit] || options[:push] || options[:tag] || options[:release]

    in_gemspec_dirs do
      run_cmd(:bump)
    end

    if @new_version_number == nil
      say "No version files could be found, so no actions were performed." unless quiet?
    else
      tasks.each do |task|
        run_cmd(task) if options[task]
      end

      success
    end
  end

  protected

    def bump
      version = VersionFile.new(:target => (@new_version_number || options[:version]))
      if File.exist?(version.filename)
        @new_version_number ||= version.new_number
        say "Bumping #{gem_name} from #{version.old_number} to version #{version.new_number}" unless quiet?
        version.bump!
        return system("git add #{version.filename}") if options[:commit]
      else
        say "Ignoring #{gem_name}. Version file #{version.filename} not found" unless quiet?
      end
      true
    end

    def commit
      say "Creating commit" unless quiet?
      system("git commit -m \"Bump to #{@new_version_number}\"")
    end

    def push
      say "Pushing to the origin git repository" unless quiet?
      system('git push origin')
    end

    def release
      cmd = ReleaseCommand.new
      [:key, :host].each do |option|
        cmd.options[option] = options[option]
      end
      cmd.options[:quiet] = options[:quiet]
      cmd.options[:quiet_success] = true
      cmd.execute
      true
    end

    def tag
      cmd = TagCommand.new
      cmd.options[:quiet] = options[:quiet]
      cmd.options[:quiet_success] = true
      cmd.options[:push_tags_only] = true
      cmd.execute
      true
    end
end
