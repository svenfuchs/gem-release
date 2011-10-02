require 'rubygems/commands/gemspec_command'
require 'core_ext/kernel/silence'

class Gem::Commands::BootstrapCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  DEFAULTS = {
    :gemspec  => true,
    :strategy => 'git',
    :scaffold => false,
    :github   => false,
    :quiet    => false
  }

  attr_reader :arguments, :usage

  def initialize(options = {})
    super 'bootstrap', 'Bootstrap a new gem source repository', DEFAULTS.merge(options)

    option :gemspec,  '-g', 'Generate a .gemspec'
    option :strategy, '-f', 'Strategy for collecting files [glob|git] in .gemspec'
    option :scaffold, '-s', 'Scaffold lib/[gem_name]/version.rb README test/'
    option :github,   '-h', 'Bootstrap a git repo, create on github and push'
    option :quiet,    '-q', 'Do not output status messages'

    @arguments = "gemname - option name of the gem, will use the current directory if not specified"
    @usage = "#{program_name} [gemname]"
  end

  def execute
    in_bootstrapped_dir do
      write_scaffold if options[:scaffold]
      write_gemspec  if options[:gemspec]
      create_repo    if options[:github]
    end
  end

  def write_gemspec
    GemspecCommand.new(:quiet => quiet?).invoke
  end

  def write_scaffold
    say 'scaffolding ...' unless quiet?

    create_file Template.new('README.md')
    create_file Template.new('LICENSE', :year => Time.now.year, :author => user_name, :email => user_email)
    create_file Template.new('Gemfile')
    create_file Template.new('Rakefile')
    create_file Template.new('test/test_helper.rb')
    create_file Version.new(options)
  end

  def create_lib
    `mkdir -p lib test`
  end

  def create_file(template)
    if File.exists?(template.filename)
      say "Skipping #{template.filename}: already exists" unless quiet?
    else
      say "Creating #{template.filename}" unless quiet?
      template.write
    end
  end

  def create_repo
    options = { :login => github_user, :token => github_token, :name  => gem_name }
    options = options.map { |name, value| "-F '#{name}=#{value}'" }.join(' ')

    say 'Bootstrapializing git repository'
    `git init`

    say 'Staging files'
    `git add .`

    say 'Creating initial commit'
    `git commit -m 'initial commit'`

    say "Adding remote origin git@github.com:#{github_user}/#{gem_name}.git"
    `git remote add origin git@github.com:#{github_user}/#{gem_name}.git`

    say 'Creating repository on Github'
    silence { `curl #{options} http://github.com/api/v2/yaml/repos/create` }

    say 'Pushing to Github'
    `git push origin master`
  end
end
