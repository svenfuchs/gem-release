require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/release_command'

class HelpersTest < MiniTest::Unit::TestCase
  include Gem::Commands
  
  test "gems_filename" do
    assert_match /gem-release-\d+\.\d+\.\d+\.gem/, ReleaseCommand.new.gem_filename
  end
  
  test "gems_version" do
    assert_match /^\d+\.\d+\.\d+$/, ReleaseCommand.new.gem_version
  end
  
  test "gemspec_filename with an cmdline argument given" do
    command = ReleaseCommand.new
    command.handle_options(['path/to/some.gemspec'])
    assert_equal 'path/to/some.gemspec', command.gemspec_filename
  end

  test "gemspec_filename with no cmdline argument given" do
    Dir.stubs(:[]).returns(['some.gemspec'])
    assert_equal 'some.gemspec', ReleaseCommand.new.gemspec_filename
  end
end
