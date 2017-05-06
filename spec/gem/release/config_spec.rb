describe Gem::Release::Config do
  let(:global) { { bump: { commit: false }, tag: { push: false }, quiet: true } }
  let(:local)  { { bump: { commit: true, push: true }, quiet: false } }

  subject { described_class.new.opts }

  describe 'by default' do
    it { should eq({}) }
  end

  describe 'env' do
    env GEM_RELEASE_QUIET: true,
        GEM_RELEASE_BUMP_COMMIT: true,
        GEM_RELEASE_BUMP_REMOTE: :foo

    it { should eq bump: { commit: true, remote: 'foo' }, quiet: true }
  end

  describe 'files' do
    describe '~/.gem_release.yml' do
      before { write '~/.gem_release.yml', YAML.dump(global) }
      it { should eq global }
    end

    describe './.gem_release.yml' do
      before { write './.gem_release.yml', YAML.dump(local) }
      it { should eq local }
    end

    describe 'both ./.gem_release.yml and ~/.gem_release.yml' do
      before { write './.gem_release.yml', YAML.dump(local) }
      before { write '~/.gem_release.yml', YAML.dump(global) }
      it { should eq local }
    end

    describe 'with an empty file' do
      before { write './.gem_release.yml', '' }
      it { should eq({}) }
    end
  end

  describe 'both env and files' do
    env GEM_RELEASE_BUMP_COMMIT: false,
        GEM_RELEASE_BUMP_TAG:    false,
        GEM_RELEASE_BUMP_PUSH:   false

    file './.gem_release.yml', YAML.dump(bump: { tag: true })
    file '~/.gem_release.yml', YAML.dump(bump: { commit: true })

    it { should eq bump: { commit: false, tag: true, push: false } }
  end
end
