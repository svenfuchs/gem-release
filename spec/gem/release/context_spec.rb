describe Gem::Release::Context do
  let(:context) { described_class.new('foo') }
  let(:ui)      { context.ui }

  describe 'run' do
    before { allow(context).to receive(:system) }
    before { context.run('ls -al') }
    it { expect(context).to have_received(:system).with('ls -al') }
  end

  describe 'gem_cmd' do
    let(:cmd) { double('cmd') }
    before { allow(Gem::Commands::BuildCommand).to receive(:new).and_return(cmd) }
    before { allow(cmd).to receive(:invoke) }
    before { context.gem_cmd(:build, 'foo.gemspec') }
    it { expect(cmd).to have_received(:invoke).with('foo.gemspec') }
  end

  describe 'abort' do
    before { allow(context).to receive(:exit) }
    before { allow(ui).to receive(:error) }
    before { context.abort('msg') }
    it { expect(ui).to have_received(:error).with('msg') }
    it { expect(context).to have_received(:exit).with(1) }
  end
end
