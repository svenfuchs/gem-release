require 'rubygems/commands/gemspec_command'
require 'core_ext/kernel/silence'

class Gem::Commands::BootstrapCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  DEFAULTS = {
    :gemspec  => true,
    :strategy => 'git',
    :scaffold => true,
    :github   => false,
    :quiet    => false
  }

  attr_reader :arguments, :usage, :name

  def initialize(options = {})
    @name = 'bootstrap'
    super @name, 'Bootstrap a new gem source repository', default_options_with(options)

    option :gemspec,  '-g', 'Generate a .gemspec'
    option :scaffold, '-s', 'Scaffold lib/[gem_name]/version.rb README test/'
    option :strategy, '-f', 'Strategy for collecting files [glob|git] in .gemspec'
    option :github,   '-h', 'Bootstrap a git repo, create on github and push'
    option :quiet,    '-q', 'Do not output status messages'

    @arguments = "gemname - option name of the gem, will use the current directory if not specified"
    @usage = "#{program_name} [gemname]"
  end

  def execute
    in_bootstrapped_dir do
      write_scaffold if options[:scaffold]
      write_gemspec  if options[:gemspec]
      init_git       if options[:github] || options[:args] # safe to 'git init' in new dir
      create_repo    if options[:github]
    end

    success
  end

  def write_gemspec
    GemspecCommand.new(:quiet => quiet?, :strategy => options[:strategy], :quiet_success => true).execute
  end

  def write_scaffold
    say 'scaffolding ...' unless quiet?

    create_file Template.new('gitignore', :filename => '.gitignore')
    create_file Template.new('README.md')
    create_file Template.new('LICENSE', :year => Time.now.year, :author => user_name, :email => user_email)
    create_file Template.new('Gemfile')
    create_file Template.new('Rakefile')
    create_file Template.new('test/test_helper.rb')
    create_file VersionTemplate.new(options)
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

  def init_git
    say 'Initializing git repository'
    `git init`
  end

  def create_repo
    options = { :login => github_user, :token => github_token, :name  => gem_name }
    options = options.map { |name, value| "-F '#{name}=#{value}'" }.join(' ')

    say 'Staging files'
    `git add .`

    say 'Creating initial commit'
    `git commit -m "initial commit"`

    say "Adding remote origin git@github.com:#{github_user}/#{gem_name}.git"
    `git remote add origin git@github.com:#{github_user}/#{gem_name}.git`

    say 'Creating repository on Github'
    silence { `curl #{options} http://github.com/api/v2/yaml/repos/create` }

    say 'Pushing to Github'
    `git push origin master`
  end
end
