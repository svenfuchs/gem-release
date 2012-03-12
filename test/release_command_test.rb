require File.expand_path('../test_helper', __FILE__)
require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/release_command'

class ReleaseCommandTest < Test::Unit::TestCase
  include Gem::Commands

  def setup
    build_sandbox(:gemspec_dirs => true)
    stub_command(BootstrapCommand, :say)
    stub_command(BuildCommand, :execute)
    stub_command(PushCommand, :execute)
    stub_command(TagCommand, :execute)
    stub_command(ReleaseCommand, :remove, :say)
    BootstrapCommand.new.send(:write_scaffold)
  end

  def teardown
    teardown_sandbox
  end

  test "build executes BuildCommand with the current gemspec filename" do
    in_gemspec_dirs do
      command = BuildCommand.new
      command.expects(:execute)
      ReleaseCommand.new.send(:build)
      assert_equal [Dir['*.gemspec'].first], command.options[:args]
    end
  end

  test "push executes PushCommand with the current gem filename" do
    in_gemspec_dirs do
      command = PushCommand.new
      command.expects(:execute)
      ReleaseCommand.new.send(:push)
      assert command.options[:args][0].include?(".gem")
    end
  end

  test "tag executes TagCommand if --tag option was given" do
    TagCommand.new.expects(:execute)
    ReleaseCommand.new.invoke('--tag')
  end

  test "passes --key args to the push command" do
    key_name = "example"
    in_gemspec_dirs do
      PushCommand.any_instance.expects(:invoke).with() { |_, a1, a2| a1 ==  "--key" && a2 == key_name }
    end
    ReleaseCommand.new.invoke('--key', key_name)
  end

  test "passes --host args to the push command" do
    host_name = "http://hostname.example.com"
    in_gemspec_dirs do
      PushCommand.any_instance.expects(:invoke).with() { |_, a1, a2| a1 ==  "--host" && a2 == host_name }
    end
    ReleaseCommand.new.invoke('--host', host_name)
  end
end
