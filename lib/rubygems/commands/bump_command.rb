require 'gem_release'
require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'
require 'shellwords'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage, :name

  DEFAULTS = {
    :version  => '',
    :commit   => true,
    :push     => false,
    :destination  => "origin",
    :tag      => false,
    :release  => false,
    :key      => '',
    :host     => '',
    :quiet    => false,
    :sign     => false,
  }

  def initialize(options = {})
    @name = 'bump'
    super @name, 'Bump the gem version', default_options_with(options)

    option :version,     '-v', 'Target version: next [major|minor|patch|pre|release] or a given version number [x.x.x]'
    option :commit,      '-c', 'Perform a commit after incrementing gem version'
    option :push,        '-p', 'Push to the git destination'
    option :destination, '-d', 'destination git repository'
    option :tag,         '-t', 'Create a git tag and push it to the git destination'
    option :release,     '-r', 'Build gem from a gemspec and push to rubygems.org'
    option :key,         '-k', 'When releasing: use the given API key from ~/.gem/credentials'
    option :host,        '-h', 'When releasing: push to a gemcutter-compatible host other than rubygems.org'
    option :quiet,       '-q', 'Do not output status messages'
    option :sign,        '-s', 'GPG sign commit message'
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
        return system("git add #{escape(version.filename)}") if options[:commit]
      else
        say "Ignoring #{gem_name}. Version file #{version.filename} not found" unless quiet?
      end
      true
    end

    def escape(string)
      Shellwords.escape(string)
    end

    def commit
      say "Creating commit" unless quiet?
      options[:sign] ? system("git commit -S -m \"Bump to #{@new_version_number}\"") : system("git commit -m \"Bump to #{@new_version_number}\"")
    end

    def push
      destination = options[:destination]
      say "Pushing to the #{destination} git repository" unless quiet?
      system("git push #{destination}")
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
      cmd.options[:destination] = options[:destination]
      cmd.execute
      true
    end
end
