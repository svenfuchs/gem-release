require 'gem_release/helpers'
require 'rubygems/commands/gemspec_command'

class Gem::Commands::BootstrapCommand < Gem::Command
  include GemRelease, Gem::Commands
  include Helpers, CommandOptions

  OPTIONS = { :gemspec => true, :strategy => 'git', :scaffold => false, :github => false }

  attr_reader :arguments, :usage
  
  def initialize
    super 'bootstrap', 'Bootstrap a new gem source repository', OPTIONS

    option :gemspec,  '-g', 'Generate a .gemspec'
    option :strategy, '-f', 'Strategy for collecting files [glob|git] in .gemspec'
    option :scaffold, '-s', 'Scaffold lib/[gem_name]/version.rb README test/'
    option :github,   '-h', 'Bootstrap a git repo, create on github and push'
  end

  def execute
    write_gemspec  if options[:gemspec]
    write_scaffold if options[:scaffold]
    create_repo    if options[:github]
  end

  def write_gemspec
    GemspecCommand.new.invoke
  end

  def write_scaffold
    say 'scaffolding lib/ README test/'
    `mkdir lib test`
    `touch README`
    write_version
    write_rakefile
  end
  
  def write_version
    version = Version.new(options)
    say "Creating #{version.filename}"
    version.write
  end

  def write_rakefile
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
