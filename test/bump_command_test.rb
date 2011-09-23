require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/bump_command'

class BumpCommandTest < Test::Unit::TestCase
  include GemRelease

  def setup
    build_sandbox(:gemspec_dirs => true)
    stub_command(BootstrapCommand, :say)
    stub_command(TagCommand, :say)
    stub_command(BumpCommand, :say)
    stub_command(ReleaseCommand, :say)
    BootstrapCommand.new.send(:write_scaffold)
  end

  def teardown
    teardown_sandbox
  end

  def version(options = {})
    VersionFile.new(options)
  end

  test "gem bump" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:`).with("git add #{version.send(:filename)}")
    end
    command.expects(:`).with('git commit -m "Bump to 0.0.2"')
    command.invoke
  end

  test "gem bump nested" do
    command = BumpCommand.new
    command.invoke('--no-commit', '--quiet')

    version_1 = File.read('lib/foo_bar/version.rb')
    assert version_1.include?('module FooBar')
    assert version_1.include?('0.0.2')

    version_2 = File.read('spec_1/lib/spec_1/version.rb')
    assert version_2.include?('module Spec1')
    assert version_2.include?('0.0.2')
  end

  test "gem bump --version 0.1.0" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:`).with("git add #{version.send(:filename)}")
    end
    command.expects(:`).with('git commit -m "Bump to 0.1.0"')
    command.invoke('--version', '0.1.0')
  end

  test "gem bump --push" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:`).with("git add #{version.send(:filename)}")
    end
    command.expects(:`).with('git commit -m "Bump to 0.0.2"')
    command.expects(:`).with('git push')
    command.invoke('--push')
  end

  test "gem bump --push --tag" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:`).with("git add #{version.send(:filename)}")
    end
    command.expects(:`).with('git commit -m "Bump to 0.0.2"')
    command.expects(:`).with('git push')
    TagCommand.any_instance.stubs(:gem_version).returns('0.0.2')
    TagCommand.any_instance.expects(:`).with("git tag -am 'tag v0.0.2' v0.0.2")
    TagCommand.any_instance.expects(:`).with('git push --tags origin')
    command.invoke('--push', '--tag')
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
    assert_equal "module FooBar\n  VERSION = \"0.0.2\"\nend\n", version.send(:bumped_content)
  end
end
