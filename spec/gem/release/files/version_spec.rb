describe Gem::Release::Files::Version do
  let(:version) { described_class.new('test', target, {}) }

  before  { write './lib/test/version.rb', %(VERSION = "#{current}") }

  describe 'given a major version' do
    let(:current) { '1.0.0' }

    describe 'given :patch (default)' do
      let(:target) { nil }
      it { expect(version.to).to eq '1.0.1' }
    end

    describe 'given :patch' do
      let(:target) { :patch }
      it { expect(version.to).to eq '1.0.1' }
    end
  end
end
