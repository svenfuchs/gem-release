# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'gem_release/version'

Gem::Specification.new do |s|
  s.name         = "gem-release"
  s.version      = GemRelease::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/gem-release"
  s.summary      = 'Release your ruby gems with ease'
  s.description  = 'Release your ruby gems with ease. (What a bold statement for such a tiny plugin ...)'

  s.files        = `git ls-files {app,lib}`.split("\n")
  s.require_path = 'lib'
  s.platform     = Gem::Platform::RUBY
  s.licenses     = ['MIT']

  s.add_development_dependency 'test_declarative', '>=0.0.2'
  s.add_development_dependency 'mocha', '>=0.14'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'coveralls'

  s.required_rubygems_version = '>= 1.3.6'
end
