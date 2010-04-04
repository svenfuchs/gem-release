$: << File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'test_declarative'
require 'mocha'

require 'rubygems'
require 'rubygems_plugin'

class Test::Unit::TestCase
  def stub_command(command_class, *methods)
    command = command_class.new
    methods.each { |method| command.stubs(method) }
    command_class.stubs(:new).returns(command)
  end
end