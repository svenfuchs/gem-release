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
  end

  def execute
    write_scaffold if options[:scaffold]
    write_gemspec  if options[:gemspec]
    create_repo    if options[:github]
  end

  def write_gemspec
    GemspecCommand.new(:quiet => quiet?).invoke
  end

  def write_scaffold
    say 'scaffolding ...' unless quiet?
    create_lib
    create_readme
    create_license
    create_gemfile
    create_test_helper
    create_version
    create_rakefile
  end

  def create_lib
    `mkdir -p lib test`
  end

  def create_readme
    `echo "# #{gem_name}" > README.md`
  end

  def create_license
    Template.new('LICENSE', :year => Time.now.year, :author => user_name, :email => user_email).write
  end

  def create_gemfile
    Template.new('Gemfile').write
  end

  def create_test_helper
    Template.new('test/test_helper.rb').write
  end

  def create_version
    version = Version.new(options)
    if File.exists?("#{version.filename}")
      say "Skipping #{version.filename}: already exists" unless quiet?
    else
      say "Creating #{version.filename}" unless quiet?
      version.write
    end
  end

  def create_rakefile
    if File.exists?('Rakefile')
      say "Skipping Rakefile: already exists" unless quiet?
    else
      say "Creating Rakefile" unless quiet?
      rakefile = <<RAKEFILE
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test
RAKEFILE
      File.open('Rakefile', 'w').write(rakefile)
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
