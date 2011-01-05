require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new(:test) do |t|
  t.pattern = "#{File.dirname(__FILE__)}/test/**/*_test.rb"
  t.verbose = true
end
Rake::Task['test'].comment = "Run all tests"

