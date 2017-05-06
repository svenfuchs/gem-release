describe Gem::Release::Cmds::Tag do
  let(:args) { [] }
  let(:opts) { {} }

  cwd 'foo-bar'
  gemspec 'foo-bar'

  describe 'by default' do
    run_cmd

    it { should run_cmd 'git tag -am "tag v1.0.0" v1.0.0' }
    it { should_not run_cmd 'git push --tags origin' }

    it { should output  'Tagging foo-bar as version 1.0.0' }
    it { should output  'Creating git tag v1.0.0' }
    it { should output  '$ git tag -am "tag v1.0.0" v1.0.0' }
    it { should_not output  'Pushing tags to the origin git repository' }
    it { should_not output  '$ git push --tags origin' }
    it { should output 'All is good, thanks my friend.' }
  end

  describe 'given --push' do
    let(:opts) { { push: true } }
    run_cmd

    it { should run_cmd 'git push --tags origin' }
    it { should output  'Pushing tags to the origin git repository' }
    it { should output  '$ git push --tags origin' }
  end

  describe 'given --remote foo' do
    let(:opts) { { push: true, remote: 'foo' } }
    remotes 'foo'
    run_cmd

    it { should run_cmd 'git push --tags foo' }
    it { should output  'Pushing tags to the foo git repository' }
    it { should output  '$ git push --tags foo' }
  end

  describe 'given --sign' do
    let(:opts) { { sign: true } }
    run_cmd

    it { should output  '$ git tag -am "tag v1.0.0" v1.0.0 --sign' }
  end

  describe 'given --quiet' do
    let(:opts) { { quiet: true } }
    run_cmd

    it { expect(out).to be_empty }
  end

  describe 'fails if there are uncommitted changes' do
    before { allow(system).to receive(:git_clean?).and_return(false) }
    it { expect { run }.to raise_error('Uncommitted changes found. Please commit or stash. Aborting.') }
  end
end
