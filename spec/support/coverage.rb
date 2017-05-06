if ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter 'app/secrets'
  end
end

