require 'pathname'
require 'rubygems'
require 'ruby-debug'

require File.expand_path('../../test_helper', __FILE__)
$: << File.expand_path('../../../lib', __FILE__)

require 'rubygems/commands/bump_command'
require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/release_command'

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

  test "truth" do
    assert true
  end

  test "can instantiate bump command" do
    assert defined?(Gem::Commands::ReleaseCommand)
    assert_kind_of ReleaseCommand, klass.new
  end

  protected
    def klass
      Gem::Commands::ReleaseCommand
    end

    def specs
      ['repo.gemspec', 'spec1/spec1.gemspec', 'spec2/spec2.gemspec',
       'spec3/spec3.gemspec', 'spec3/spec4/spec4.gemspec']
    end
end
