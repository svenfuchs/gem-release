require File.expand_path('../test_helper', __FILE__)

require 'rubygems/commands/bootstrap_command'
require 'gem_release/gemspec'
require 'fileutils'

class BootstrapCommandTest < Test::Unit::TestCase
  def setup
    build_sandbox
    stub_command(GemspecCommand, :execute)
    stub_command(BootstrapCommand, :say)
  end

  def teardown
    teardown_sandbox
  end

  test "write_scaffold" do
    BootstrapCommand.new.send(:write_scaffold)

    assert File.file?('lib/foo_bar/version.rb')
    assert File.file?('README')
    assert File.directory?('test')

    eval(File.read('lib/foo_bar/version.rb'))
    assert_equal '0.0.1', FooBar::VERSION
  end

  test "write_gemspec" do
    GemspecCommand.new.expects(:execute)
    BootstrapCommand.new.send(:write_gemspec)
  end

  test "create_repo" do
    command = BootstrapCommand.new
    command.stubs(:say)
    command.stubs(:github_user).returns('svenfuchs')
    command.stubs(:github_token).returns('token')

    command.expects(:`).with("git init")
    command.expects(:`).with("git add .")
    command.expects(:`).with("git commit -m 'initial commit'")
    command.expects(:`).with("git remote add origin git@github.com:svenfuchs/foo-bar.git")
    command.expects(:`).with("git push origin master")
    command.expects(:`).with do |cmd|
      tokens = %w(curl login=svenfuchs name=foo-bar token=token http://github.com/api/v2/yaml/repos/create)
      tokens.inject(true) { |result, token| result && cmd =~ /#{token}/ }
    end

    command.send(:create_repo)
  end
end
