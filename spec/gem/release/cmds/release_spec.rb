describe Gem::Release::Cmds::Release do
  let(:args) { [] }
  let(:opts) { {} }

  cwd 'foo-bar'

  describe 'by default' do
    gemspec 'foo-bar'
    run_cmd

    it { should run_cmd 'gem build foo-bar.gemspec' }
    it { should run_cmd 'gem push foo-bar-1.0.0.gem' }

    it { should output  'Deleting left over gem file foo-bar-1.0.0.gem' }
    it { run_cmd 'rm foo-bar-1.0.0.gem' }

    it { should output 'All is good, thanks my friend.' }
  end

  describe 'given two gem names' do
    let(:args) { ['foo', 'bar'] }

    gemspec 'foo/foo'
    gemspec 'bar/bar'
    run_cmd

    it { should run_cmd 'gem build foo.gemspec' }
    it { should run_cmd 'gem build bar.gemspec' }
  end

  describe 'given --recurse' do
    let(:opts) { { recurse: true } }

    gemspec 'foo/foo'
    gemspec 'bar/bar'
    run_cmd

    it { should run_cmd 'gem build foo.gemspec' }
    it { should run_cmd 'gem build bar.gemspec' }
  end

  describe 'given --host' do
    let(:opts) { { host: 'host' } }

    gemspec 'foo-bar'
    run_cmd

    it { should run_cmd 'gem push foo-bar-1.0.0.gem --host host' }
  end

  describe 'given --key' do
    let(:opts) { { key: 'key' } }

    gemspec 'foo-bar'
    run_cmd

    it { should run_cmd 'gem push foo-bar-1.0.0.gem --key key' }
  end

  describe 'given --tag' do
    let(:opts) { { tag: true } }

    gemspec 'foo-bar'
    run_cmd

    it { should run_cmd 'git tag -am "tag v1.0.0" v1.0.0' }
  end

  describe 'given --quiet' do
    let(:opts) { { quiet: true } }

    run_cmd

    it { expect(out).to be_empty }
  end
end
