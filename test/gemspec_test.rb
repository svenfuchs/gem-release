require File.expand_path('../test_helper', __FILE__)

require 'gem_release/version'
require 'gem_release/gemspec'

class GemspecTest < MiniTest::Unit::TestCase
  include Gem::Commands
  
  test 'scaffolds a gemspec with default values' do
    source  = GemRelease::Gemspec.new.render
    gemspec = eval(source)

    user = %x[git config --get user.name].strip
    email = %x[git config --get user.email].strip
    github_user = %x[git config --get github.user].strip

    assert_equal 'gem-release', gemspec.name
    assert_equal GemRelease::VERSION, gemspec.version.to_s
    # will work with local git config
    assert_equal [user], gemspec.authors
    assert_equal email, gemspec.email
    assert_equal "http://github.com/#{github_user}/gem-release", gemspec.homepage
    assert_equal '[summary]', gemspec.summary
    assert_equal '[description]', gemspec.description
    
    assert_match %r(require 'gem_release/version'), source

    assert_match %r(files\s*=[^$]*git ls\-files), source
  end
  
  test 'scaffolds a gemspec with glob strategy' do
    source  = GemRelease::Gemspec.new(:strategy => 'glob').render
    gemspec = eval(source)
    assert_match %r(files\s*=\s*Dir.glob\(\"lib\/\*\*\/\*\*\"\)), source
  end

  test 'filename' do
    assert_equal 'gem-release.gemspec', GemRelease::Gemspec.new.filename
  end

end
