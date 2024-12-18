require 'support/coverage'

require 'gem/release'

require 'support/context'
require 'support/env'
require 'support/files'
require 'support/matchers'
require 'support/now'
require 'support/run'
require 'support/tty'

require 'webmock'
require 'webmock/rspec'

ENV.delete_if { |key, _| key.start_with?('GEM_RELEASE') }

Kernel.send(:undef_method, :system)
Kernel.send(:undef_method, :abort)

RSpec.configure do |c|
  c.include Support::Context
  c.include Support::Env
  c.include Support::Files
  c.include Support::Now
  c.include Support::Run
  c.include Support::Tty

  c.before :suite do
    # Ensure no request really sent
    WebMock.disable_net_connect!(:allow_localhost => false)
  end
end
