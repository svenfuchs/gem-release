require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/bump_command'

class BumpCommandTest < Test::Unit::TestCase
  include GemRelease
  
  def setup
    build_sandbox
    stub_command(BootstrapCommand, :say)
    stub_command(BumpCommand, :say)
    BootstrapCommand.new.send(:write_scaffold)
  end
  
  def teardown
    @version = nil
    teardown_sandbox
  end
  
  def version(options = {})
    @version ||= VersionFile.new(options)
  end
  
  test "gem bump" do
    command = BumpCommand.new
    command.expects(:`).with("git add #{version.send(:filename)}")
    command.expects(:`).with('git commit -m "Bump to 0.0.2"')
    command.invoke
  end
  
  test "gem bump --push" do
    command = BumpCommand.new
    command.expects(:`).with("git add #{version.send(:filename)}")
    command.expects(:`).with('git commit -m "Bump to 0.0.2"')
    command.expects(:`).with('git push')
    command.invoke('--push')
  end
  
  test "old_number" do
    assert_equal '0.0.1', version.old_number
  end
  
  test "new_number w/ default target" do
    assert_equal '0.0.2', version.new_number
  end
  
  test "new_number w/ :patch target" do
    assert_equal '0.0.2', version(:target => :patch).new_number
  end
  
  test "new_number w/ :minor target" do
    assert_equal '0.1.0', version(:target => :minor).new_number
  end
  
  test "new_number w/ :major target" do
    assert_equal '1.0.0', version(:target => :major).new_number
  end
  
  test "new_number w/ given version number" do
    assert_equal '1.1.1', version(:target => '1.1.1').new_number
  end
  
  test "bumped_content" do
    assert_equal "module FooBar\n  VERSION = \"0.0.2\"\nend", version.send(:bumped_content)
  end
end