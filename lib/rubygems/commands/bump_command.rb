require 'rubygems/commands/tag_command'
require 'rubygems/commands/release_command'
require 'ruby-debug'

class Gem::Commands::BumpCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  attr_reader :arguments, :usage
  attr_accessor :my_options

  OPTIONS = { :version => 'patch',
              :push    => false,
              :tag     => false,
              :release => false,
              :commit  => true,
              :recurse => false }

  def initialize(my_options=nil)
    my_options.nil? ? @my_options={} : @my_options=OPTIONS.merge(my_options)
      
    super('bump', 'Bump the gem version', OPTIONS)

    option :version, '-v', 'Target version: next [major|minor|patch] or a given version number [x.x.x]'
    option :push,    '-p', 'Push to origin'
    option :tag,     '-t', 'Create a git tag and push --tags to origin'
    option :release, '-r', 'Build gem from a gemspec and push to rubygems.org'
    option :commit,  '-c', 'Perform a commit after incrementing gem version'
    option :recurse, '-R', 'Recurse current directory and include other gems in actions'
  end

  def execute
    merge_options
    if(options[:recurse])
      specdirs.each do |dir|
        Dir.chdir(dir) do
          cmd=BumpCommand.new(options.merge({:recurse=>false}))
          cmd.invoke
          commit  if options[:commit]
          release if options[:release]
          push    if options[:push] || options[:tag]
          tag     if options[:tag]
        end
      end
    else
      bump
      commit  if options[:commit]
      push    if options[:push] || options[:tag]
      release if options[:release]
      tag     if options[:tag]
    end
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

    def merge_options
      options.merge!(my_options)
    end

    def gemspecs
      Dir.glob('**/*.gemspec')
    end

    def specdirs
      gemspecs.map{|spec| File.dirname(spec)}
    end
    
    #def libdirs(dirs)
    #  #dirs.map{|dir| File.join(dir, 'lib')}
    #  specdirs(dirs).map{|dir| File.join(dir, 'lib')}
    #end
end
