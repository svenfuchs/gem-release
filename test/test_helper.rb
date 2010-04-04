$: << File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test_declarative'
require 'mocha'

require 'rubygems'
require 'rubygems_plugin'

class Test::Unit::TestCase
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
end