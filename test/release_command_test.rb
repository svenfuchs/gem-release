require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/release_command'

class ReleaseCommandTest < Test::Unit::TestCase
  include Gem::Commands
  
  def setup
    stub_command(BuildCommand, :execute)
    stub_command(PushCommand, :execute)
    stub_command(TagCommand, :execute)
    stub_command(ReleaseCommand, :remove, :say)
  end
  
  test "build executes BuildCommand with the current gemspec filename" do
    command = BuildCommand.new
    command.expects(:execute)
    ReleaseCommand.new.send(:build)
    assert_equal ['gem-release.gemspec'], command.options[:args]
  end
  
  test "push executes PushCommand with the current gem filename" do
    command = PushCommand.new
    command.stubs(:gem_filename).returns('gem-release-0.0.5.gem')
    command.expects(:execute)
    ReleaseCommand.new.send(:push)
    assert_equal ['gem-release-0.0.5.gem'], command.options[:args]
  end
  
  test "tag executes TagCommand if --tag option was given" do
    TagCommand.new.expects(:execute)
    ReleaseCommand.new.invoke('--tag')
  end
end