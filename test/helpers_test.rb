require File.expand_path('../test_helper', __FILE__)
require 'rubygems/commands/release_command'

class HelpersTest < Test::Unit::TestCase
  include Gem::Commands

  def setup
    def command
      @cmd ||= ReleaseCommand.new
    end
  end

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

  test "rejects gemspecs located in vendor directory" do
    files = %w(lib/foo.gemspec vendor/baz.gemspec)
    output = command.filter_gemspecs(files)
    assert_equal %w(lib), output
  end

  test "keeps multiple non-vendor gemspecs" do
    files = ['lib/foo.gemspec', 'bin/baz.gemspec', 'src/bar.gemspec']
    output = command.filter_gemspecs(files)
    assert_equal %w(lib bin src), output
  end

  test "finds non-top-level vendor folders" do
    files = ['lib/foo.gemspec', 'lib/vendor/baz.gemspec']
    output = command.filter_gemspecs(files)
    assert_equal %w(lib lib/vendor), output
  end

  test "#gemspec_dirs ignores vendored gemspecs" do
    files = %w(lib/foo.gemspec vendor/baz.gemspec)
    Dir.stubs(:glob).returns(files)
    output = command.gemspec_dirs
    assert_equal %w(lib), output
  end
end
