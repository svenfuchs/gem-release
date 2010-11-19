require 'pathname'
require 'rubygems'
require 'ruby-debug'

require File.expand_path('../../test_helper', __FILE__)
$: << File.expand_path('../../../lib', __FILE__)

require 'rubygems/commands/bump_command'
require 'rubygems/commands/bootstrap_command'

class TestRecurse < Test::Unit::TestCase
  def setup
    @cwd=Dir.pwd
    @recursive_specs=['tmp/gem-release-test/repo/',
                      'tmp/gem-release-test/repo/spec1',
                      'tmp/gem-release-test/repo/spec2',
                      'tmp/gem-release-test/repo/spec3',
                      'tmp/gem-release-test/repo/spec3/spec4']
    @recursive_specs.each do |dir|
      project = dir.split('/').last
      FileUtils.mkdir_p(dir)
      Dir.chdir(dir)
      bs = BootstrapCommand.new
      bs.send(:write_scaffold)
      bs.send(:write_gemspec)
      FileUtils.touch("#{project}.gemspec")
      Dir.chdir(@cwd)
    end

    @bump_command=klass.new

    Dir.chdir('tmp/gem-release-test/repo')
  end

  def teardown
    Dir.chdir(@cwd)
    FileUtils.rm_rf('tmp')
  end

  test "can instantiate bump command" do
    assert defined?(Gem::Commands::BumpCommand)
    assert_kind_of BumpCommand, klass.new
  end

  test "defined methods" do
    assert_respond_to klass.new, :gemspecs
    assert_respond_to klass.new, :specdirs
    #assert_respond_to klass.new, :libdirs
  end

  test "can invoke non-recursive bump" do
    assert_nothing_raised do
      @bump_command.invoke()
    end
    assert_equal 'patch', @bump_command.send(:version).target
  end

  test "can invoke recursive bump" do
    assert_nothing_raised do
      @bump_command.invoke('--recurse')
    end
    assert_equal 'patch', @bump_command.send(:version).target
  end

  test "can invoke bump with options" do
    assert_nothing_raised do
      @bump_command.invoke('--version', '0.15.1')
    end
    assert_equal '0.15.1', @bump_command.send(:version).target
  end

  test "can invoke recursive bump with --version 3.3.3." do
    assert_nothing_raised do
      @bump_command.invoke('--version', '3.3.3', '--recurse')
    end
    assert_equal '3.3.3', @bump_command.send(:version).target
  end

  ### DANGER: do not run this test because you'll push a bogus gem
  ##test "can invoke recurse bump with --version 0.8.0 --no-commit --release" do
  ##  assert_nothing_raised do
  ##    @bump_command.invoke('--version', '0.8.0', '--recurse', '--no-commit', '--release')
  ##  end
  ##end

  ### DANGER: do not run this test because you'll push a bogus gem
  ##test "can invoke recurse bump with --version 0.8.0 --no-commit --release" do
  ##  assert_nothing_raised do
  ##    @bump_command.invoke('--version', '0.8.0', '--recurse', '--no-commit', '--release')
  ##  end
  ##end
  
  ### can't be tested well because of pushes to origin
  ##test "can invoke recurse bump with --version 0.8.0 --tag --no-commit" do
  ##  assert_nothing_raised do
  ##    @bump_command.invoke('--version', '0.8.0', '--tag', 'v0.8.0', '--no-commit')
  ##  end
  ##end
  ##

  test "gemspecs returns array of relative paths to gemspec files" do
    assert_kind_of Array, @bump_command.send(:gemspecs)
    assert_equal specs.sort, @bump_command.send(:gemspecs).sort
  end

  test "specdirs returns an array of all the directories with gemspecs" do
    assert_kind_of Array, @bump_command.send(:specdirs)
    dirs=['.', 'spec1', 'spec2', 'spec3', 'spec3/spec4']
    assert_equal dirs.sort, @bump_command.send(:specdirs).sort
  end

  test "versions actually get bumped" do
    @bump_command.send(:specdirs).each do |dir|
      Dir.chdir(dir) do
        #klass.new().send(:bump)
        klass.new().invoke()
      end
    end
  end

  protected
    def klass
      Gem::Commands::BumpCommand
    end

    def specs
      ['repo.gemspec', 'spec1/spec1.gemspec', 'spec2/spec2.gemspec',
       'spec3/spec3.gemspec', 'spec3/spec4/spec4.gemspec']
    end
end
