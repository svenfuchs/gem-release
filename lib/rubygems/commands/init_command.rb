require 'gem_release/helpers'

class Gem::Commands::InitCommand < Gem::Command
  include GemRelease
  include Helpers, CommandOptions

  OPTIONS = {
    :gemspec  => true,
    :scaffold => false,
    :github   => false
  }

  attr_reader :arguments, :usage
  
  def initialize
    super 'init', 'Initialize a new gem source repository', OPTIONS

    option :gemspec,  '-g', 'Generate a .gemspec'
    option :scaffold, '-s', 'Scaffold lib/[gem_name]/version.rb README test/'
    option :github,   '-h', 'Init a git repo, create on github and push'

    @arguments = ''
    @usage = "#{program_name}"
  end

  def execute
    write_gemspec  if options[:gemspec]
    write_scaffold if options[:scaffold]
    create_repo    if options[:github]
  end

  def write_scaffold
    `mkdir lib test`
    `touch README`
    Version.new(options).write
  end

  def write_gemspec
    Gemspec.new(options).write
  end

  def create_repo
    options = { :login => github_user, :token => github_token, :name  => gem_name }
    options = options.map { |name, value| "-F '#{name}=#{value}'" }.join(' ')
    
    say 'Initializing git repository'
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