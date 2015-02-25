require File.expand_path('../test_helper', __FILE__)
require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/bump_command'

class BumpCommandTest < Test::Unit::TestCase
  include GemRelease

  def setup
    build_sandbox(:gemspec_dirs => true)
    stub_command(BootstrapCommand, :say)
    stub_command(BumpCommand, :say)
    stub_command(TagCommand, :say)
    stub_command(ReleaseCommand, :say)
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
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.invoke
  end

  test "gem bump nested" do
    command = BumpCommand.new
    command.invoke('--no-commit', '--quiet')

    version_1 = File.read('lib/foo-bar/version.rb')
    assert version_1.include?('module Foo')
    assert version_1.include?('module Bar')
    assert version_1.include?('0.0.2')

    version_2 = File.read('spec_1/lib/spec_1/version.rb')
    assert version_2.include?('module Spec1')
    assert version_2.include?('0.0.2')
  end

  test "gem bump with version in lib/foo/bar/" do
    # move version.rb to the alternate dir: /lib/foo/bar
    FileUtils.mkdir('lib/foo')
    FileUtils.mkdir('lib/foo/bar')
    FileUtils.move('lib/foo-bar/version.rb', 'lib/foo/bar')

    command = BumpCommand.new
    command.invoke('--no-commit', '--quiet')

    version_1 = File.read('lib/foo/bar/version.rb')
    assert version_1.include?('0.0.2')
  end

  test "gem bump with with space in path" do
    path_with_space = "lib/foo bar"
    expected = 'lib/foo\\ bar'
    path = BumpCommand.new.send(:escape, path_with_space)
    assert_equal expected, path
  end

  test "gem bump without space in path" do
    path_without_space = "lib/foo_bar"
    expected = 'lib/foo_bar'
    path = BumpCommand.new.send(:escape, path_without_space)
    assert_equal expected, path
  end

  test "gem bump with version in lib/foo_bar/" do
    # move version.rb to the alternate dir: /lib/foo_bar
    FileUtils.mkdir('lib/foo_bar')
    FileUtils.move('lib/foo-bar/version.rb', 'lib/foo_bar')

    command = BumpCommand.new
    command.invoke('--no-commit', '--quiet')

    version_1 = File.read('lib/foo_bar/version.rb')
    assert version_1.include?('0.0.2')
  end

  test "gem bump --version 0.1.0" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0"').returns(true)
    command.invoke('--version', '0.1.0')
  end

  test "`gem bump --version pre`, followed by `gem bump`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2.pre1"').returns(true)
    command.invoke('--version', 'pre')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2.pre2"').returns(true)
    command.invoke()
  end

  test "`gem bump --version 0.1.0.beta1`, followed by `gem bump`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.beta1"').returns(true)
    command.invoke('--version', '0.1.0.beta1')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.beta2"').returns(true)
    command.invoke()
  end

  test "`gem bump --version 0.1.0.beta1`, followed by `gem bump --version release`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.beta1"').returns(true)
    command.invoke('--version', '0.1.0.beta1')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0"').returns(true)
    command.invoke('--version', 'release')
  end

  test "`gem bump --version 0.1.0`, followed by `gem bump --version release`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0"').returns(true)
    command.invoke('--version', '0.1.0')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.1"').returns(true)
    command.invoke('--version', 'release')
  end

  test "`gem bump --version 0.1.0.1`, followed by `gem bump`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.1"').returns(true)
    command.invoke('--version', '0.1.0.1')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.2"').returns(true)
    command.invoke()
  end

  test "`gem bump --version 0.1.0.beta1`, followed by `gem bump --version patch`" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.0.beta1"').returns(true)
    command.invoke('--version', '0.1.0.beta1')

    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.1.1"').returns(true)
    command.invoke('--version', 'patch')
  end

  test "gem bump --push" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push origin').returns(true)
    command.invoke('--push')
  end

  test "gem bump --push -d fork" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push fork').returns(true)
    command.invoke('--push', '-d', 'fork')
  end

  test "gem bump --tag" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push origin').returns(true)

    TagCommand.new.expects(:system).with("git tag -am \"tag v0.0.2\" v0.0.2").returns(true)
    TagCommand.new.expects(:system).with('git push origin v0.0.2').returns(true)
    command.invoke('--tag')
  end

  test "gem bump --tag -d fork" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push fork').returns(true)

    TagCommand.new.expects(:system).with("git tag -am \"tag v0.0.2\" v0.0.2").returns(true)
    TagCommand.new.expects(:system).with('git push fork v0.0.2').returns(true)
    command.invoke('--tag', '-d', 'fork')
  end

  test "gem bump --push --release" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push origin').returns(true)

    count = gemspec_dirs.size
    ReleaseCommand.any_instance.expects(:build).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:push).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:cleanup).times(count).returns(true)

    command.invoke('--push', '--release')
  end

  test "gem bump --tag --release" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push origin').returns(true)

    count = gemspec_dirs.size
    ReleaseCommand.any_instance.expects(:build).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:push).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:cleanup).times(count).returns(true)

    TagCommand.any_instance.expects(:tag).returns(true)
    TagCommand.any_instance.expects(:push).returns(true)

    command.invoke('--tag', '--release')
  end

  test "gem bump --tag --release --destination fork" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)
    command.expects(:system).with('git push fork').returns(true)

    count = gemspec_dirs.size
    ReleaseCommand.any_instance.expects(:build).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:push).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:cleanup).times(count).returns(true)

    TagCommand.any_instance.expects(:tag).returns(true)
    TagCommand.any_instance.expects(:push).returns(true)

    command.invoke('--tag', '--release', '--destination', 'fork')
  end

  test "gem bump --release --key" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)

    count = gemspec_dirs.size
    ReleaseCommand.any_instance.expects(:build).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:cleanup).times(count).returns(true)

    keyname = "keyname"
    in_gemspec_dirs do
      PushCommand.any_instance.expects(:invoke).with() { |_, a1, a2| a1 ==  "--key" && a2 == keyname }.returns(true)
    end

    command.invoke('--release', '--key', keyname)
  end

  test "gem bump --release --host" do
    command = BumpCommand.new
    in_gemspec_dirs do
      command.expects(:system).with("git add #{version.send(:filename)}").returns(true)
    end
    command.expects(:system).with('git commit -m "Bump to 0.0.2"').returns(true)

    count = gemspec_dirs.size
    ReleaseCommand.any_instance.expects(:build).times(count).returns(true)
    ReleaseCommand.any_instance.expects(:cleanup).times(count).returns(true)

    hostname = "http://hostname.example.com"
    in_gemspec_dirs do
      PushCommand.any_instance.expects(:invoke).with() { |_, a1, a2| a1 ==  "--host" && a2 == hostname }.returns(true)
    end

    command.invoke('--release', '--host', hostname)
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

  test "new_number w/ :pre target" do
    assert_equal '0.0.2.pre1', version(:target => :pre).new_number
  end

  test "new_number w/ :rc target" do
    assert_equal '0.0.2.rc1', version(:target => :rc).new_number
  end

  test "new_number w/ :beta target" do
    assert_equal '0.0.2.beta1', version(:target => :beta).new_number
  end

  test "new_number w/ given version number" do
    assert_equal '1.1.1', version(:target => '1.1.1').new_number
  end

  test "bumped_content" do
    assert_equal "module Foo\n  module Bar\n    VERSION = \"0.0.2\"\n  end\nend\n", version.send(:bumped_content)
  end
end
