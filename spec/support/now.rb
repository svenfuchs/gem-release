module Support
  module Now
    NOW = Time.now

    def self.included(base)
      base.let(:now) { NOW }
      base.before { allow(Time).to receive(:now).and_return NOW }
    end
  end
end
