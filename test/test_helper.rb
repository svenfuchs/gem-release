require 'rubygems'
require 'rubygems_plugin'

require 'test/unit'
require 'fileutils'
require 'pathname'
require 'bundler/setup'
require 'test_declarative'
require 'test/unit/testcase'
require 'test/unit'
require 'mocha'
require 'ruby-debug'
require 'rubygems/commands/bootstrap_command'

class Test::Unit::TestCase
  include Gem::Commands

  attr_reader :base_dir, :spec_dirs

  def build_sandbox(options = {})
    FileUtils.rm_r('tmp') if File.exists?('tmp')

    @cwd       = Dir.pwd
    @base_dir  = Pathname.new('tmp/foo-bar')

    base_dir.mkpath
    spec_dirs.each do |dir|
      dir.mkpath
      Dir.chdir(dir) do
        BootstrapCommand.new(:scaffold => true, :quiet => true).execute
      end
    end

    Dir.chdir(base_dir)
  end

  def teardown_sandbox
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp')
  end

  def spec_dirs
    @spec_dirs ||= %w(. spec_1 spec_2 nested/spec_3).map { |dir| base_dir.join(dir) }
  end

  def stub_exec(klass, commands)
    commands.each do |command, result|
      klass.any_instance.stubs(:`).with(command).returns(result)
    end
  end

  def stub_command(command_class, *methods)
    command = command_class.new
    methods.each { |method| command.stubs(method) }
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
