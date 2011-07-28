require File.expand_path('../test_helper', __FILE__)

require 'gem_release/version'
require 'gem_release/gemspec'

class GemspecTest < Test::Unit::TestCase
  include Gem::Commands

  def setup
    build_sandbox
    stub_exec(GemRelease::Gemspec,
      'git config --get user.name'   => 'John Doe',
      'git config --get user.email'  => 'john@example.org',
      'git config --get github.user' => 'johndoe'
    )
  end

  def teardown
    teardown_sandbox
  end

  test 'scaffolds a gemspec with default values' do
    source  = GemRelease::Gemspec.new.send(:render)
    gemspec = eval(source)

    assert_equal 'foo-bar', gemspec.name
    assert_equal '0.0.1', gemspec.version.to_s
    assert_equal ['John Doe'], gemspec.authors
    assert_equal 'john@example.org', gemspec.email
    assert_equal "http://github.com/johndoe/foo-bar", gemspec.homepage
    assert_equal '[summary]', gemspec.summary
    assert_equal '[description]', gemspec.description

    assert_match %r(require 'foo_bar/version'), source
    assert_match %r(files\s*=\s*Dir.glob\(), source
  end

  test 'scaffolds a gemspec with glob strategy' do
    source  = GemRelease::Gemspec.new(:strategy => 'glob').send(:render)
    gemspec = eval(source)
    assert_match %r(files\s*=\s*Dir.glob\(), source
  end

  test 'scaffolds a gemspec with git strategy' do
    source  = GemRelease::Gemspec.new(:strategy => 'git').send(:render)
    gemspec = eval(source)
    assert_match %r(files\s*=[^$]*git ls\-files), source
  end

  test 'filename' do
    assert_equal 'foo-bar.gemspec', GemRelease::Gemspec.new.filename
  end

end
