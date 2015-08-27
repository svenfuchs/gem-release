require 'rubygems'
require 'rubygems_plugin'
require 'bundler/setup'

require 'test/unit'
require 'fileutils'
require 'pathname'
require 'bundler/setup'
require 'test_declarative'
require 'test/unit/testcase'
require 'test/unit'
require 'mocha/setup'

# For code coverage, must be required before all application / gem / library code.
if ENV['COVERAGE'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end

class Test::Unit::TestCase
  include Gem::Commands

  attr_reader :base_dir, :gemspec_dirs

  def build_sandbox(options = {})
    FileUtils.rm_r('tmp') if File.exists?('tmp')

    @cwd       = Dir.pwd
    @base_dir  = Pathname.new('tmp/foo-bar')

    base_dir.mkpath
    if options[:gemspec_dirs]
      gemspec_dirs.each do |dir|
        dir.mkpath
        Dir.chdir(dir) do
          BootstrapCommand.new(:scaffold => true, :quiet => true).execute
        end
      end
    end
    Dir.chdir(base_dir)
  end

  def teardown_sandbox
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp')
  end

  def gemspec_dirs
    @gemspec_dirs ||= %w(. spec_1 spec_2 nested/spec_3).map { |dir| base_dir.join(dir) }
  end

  def in_gemspec_dirs
    Dir.chdir(@cwd) do
      gemspec_dirs.each do |dir|
        Dir.chdir(dir) { yield }
      end
    end
  end

  def stub_exec(klass, commands)
    commands.each do |command, result|
      klass.any_instance.stubs(:`).with(command).returns(result)
    end
  end

  def stub_command(command_class, *methods)
    command = command_class.new
    methods.each { |method| command.stubs(method).returns(true) }
    command_class.stubs(:new).returns(command)
  end

  def capture_io
    require 'stringio'

    orig_stdout, orig_stderr         = $stdout, $stderr
    captured_stdout, captured_stderr = StringIO.new, StringIO.new
    $stdout, $stderr                 = captured_stdout, captured_stderr

    yield

    [captured_stdout.string, captured_stderr.string]
  ensure
    $stdout = orig_stdout
    $stderr = orig_stderr
  end
end
