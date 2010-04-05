$: << File.expand_path('../../lib', __FILE__)

require 'minitest/unit'
require 'test_declarative'
require 'mocha'

require 'rubygems'
require 'rubygems_plugin'

MiniTest::Unit.autorun

class MiniTest::Unit::TestCase
  include Gem::Commands

  def build_sandbox
    @cwd = Dir.pwd
    FileUtils.mkdir_p('tmp/foo-bar')
    Dir.chdir('tmp/foo-bar')
  end

  def teardown_sandbox
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp/foo-bar')
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