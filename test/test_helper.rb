$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'rubygems_plugin'

require 'test/unit'
require 'ruby-debug'
require 'fileutils'
require 'bundler/setup'
require 'test_declarative'
require 'mocha'

class Test::Unit::TestCase
  include Gem::Commands

  def build_sandbox
    @cwd = Dir.pwd
    FileUtils.mkdir_p('tmp/gem-release-test/foo-bar')
    Dir.chdir('tmp/gem-release-test/foo-bar')
  end

  def teardown_sandbox
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp')
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
