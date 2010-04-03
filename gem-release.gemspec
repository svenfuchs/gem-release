# encoding: utf-8

require File.expand_path('../lib/gem_release/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'gem-release'
  s.version      = GemRelease::VERSION
  s.authors      = ['Sven Fuchs']
  s.email        = 'svenfuchs@artweb-design.de'
  s.homepage     = 'http://github.com/svenfuchs/gem-release'
  s.summary      = 'Release your ruby gems with ease'
  s.description  = 'Release your ruby gems with ease. (What a bold statement for such a tiny plugin ...)'
  s.files        = Dir['{lib/**/*,[A-Z]*}']

  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'
end
