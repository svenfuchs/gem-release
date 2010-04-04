require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/init_command'
require 'gem_release/gemspec'
require 'fileutils'

class InitCommandTest < Test::Unit::TestCase
  include Gem::Commands

  def setup
    @cwd = Dir.pwd
    FileUtils.mkdir_p('tmp/foo-bar')
    Dir.chdir('tmp/foo-bar')

    InitCommand.new.send(:write_scaffold)
  end

  def teardown
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp/foo-bar')
  end

  test "write_scaffold" do
    assert File.file?('lib/foo_bar/version.rb')
    assert File.file?('README')
    assert File.directory?('test')

    eval(File.read('lib/foo_bar/version.rb'))
    assert_equal '0.0.1', FooBar::VERSION
  end

  test "write_gemspec" do
    InitCommand.new.send(:write_gemspec)

    filename = 'foo-bar.gemspec'
    assert File.exists?(filename)
    assert_equal 'foo-bar', eval(File.read(filename)).name
  end

  test "create_repo" do
    command = InitCommand.new
    command.stubs(:say)
    command.stubs(:github_user).returns('svenfuchs')
    command.stubs(:github_token).returns('token')

    command.expects(:`).with("curl -F 'login=svenfuchs' -F 'name=foo-bar' -F 'token=token' http://github.com/api/v2/yaml/repos/create")
    command.expects(:`).with("git init")
    command.expects(:`).with("git add .")
    command.expects(:`).with("git commit -m 'initial commit'")
    command.expects(:`).with("git remote add origin git@github.com:svenfuchs/foo-bar.git")
    command.expects(:`).with("git push origin master")

    command.send(:create_repo)
  end
end