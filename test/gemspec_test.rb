require File.expand_path('../test_helper', __FILE__)
require 'rubygems/commands/bootstrap_command'
require 'gem_release/gemspec_template'

class GemspecTest < Test::Unit::TestCase
  include Gem::Commands

  def setup
    build_sandbox(:gemspec_dirs => true)
    stub_exec(GemRelease::GemspecTemplate,
      'git config --get user.name'   => 'John Doe',
      'git config --get user.email'  => 'john@example.org',
      'git config --get github.user' => 'johndoe'
    )
  end

  def teardown
    teardown_sandbox
  end

  test 'scaffolds a gemspec with default values' do
    source  = GemRelease::GemspecTemplate.new.send(:render)
    gemspec = eval(source)

    assert_equal 'foo-bar', gemspec.name
    # NOTE: let's skip the version test because the version file required in the gemspec will not be eval'd properly
    #       when it has been already been required by a previous test
    # assert_equal '0.0.1', gemspec.version.to_s
    assert_equal ['John Doe'], gemspec.authors
    assert_equal ['john@example.org'], gemspec.email
    assert_equal "https://github.com/johndoe/foo-bar", gemspec.homepage
    assert_equal 'TODO: summary', gemspec.summary
    assert_equal 'TODO: description', gemspec.description

    assert_match %r(require 'foo-bar/version'), source
    assert_match %r(files\s*=\s*Dir.glob\(), source
  end

  test 'scaffolds a gemspec with glob strategy' do
    source  = GemRelease::GemspecTemplate.new(:strategy => 'glob').send(:render)
    assert_match %r(files\s*=\s*Dir.glob\(), source
  end

  test 'scaffolds a gemspec with git strategy' do
    source  = GemRelease::GemspecTemplate.new(:strategy => 'git').send(:render)
    assert_match %r(files\s*=[^$]*git ls\-files), source
  end

  test 'filename' do
    assert_equal 'foo-bar.gemspec', GemRelease::GemspecTemplate.new.filename
  end

end
