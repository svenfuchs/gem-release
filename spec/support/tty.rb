module Support
  module Tty
    def self.included(base)
      base.before { allow($stdout).to receive(:tty?).and_return true }
    end
  end
end
