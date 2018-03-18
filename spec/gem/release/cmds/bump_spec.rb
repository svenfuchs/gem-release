describe Gem::Release::Cmds::Bump do
  let(:args) { [] }
  let(:opts) { {} }

  describe 'by default' do
    cwd     'foo-bar'
    version 'lib/foo/bar'
    run_cmd

    it { should output "Bumping foo-bar from version 1.0.0 to 1.0.1" }
    it { should output 'Creating commit' }
    it { should output 'All is good, thanks my friend.' }

    it { should run_cmd "git add lib/foo/bar/version.rb" }
    it { should run_cmd "git commit -m \"Bump foo-bar to 1.0.1\"" }
    it { should have_version 'lib/foo/bar', "1.0.1" }
  end

  describe 'given two gem names' do
    let(:args) { ['foo', 'bar'] }
    version 'lib/foo'
    gemspec 'foo'
    version 'lib/bar', '2.0.0'
    gemspec 'bar', '2.0.0'
    run_cmd

    it { should output "Bumping foo from version 1.0.0 to 1.0.1" }
    it { should output "Bumping bar from version 2.0.0 to 2.0.1" }
  end

  describe 'given a gem name of a nested gem' do
    let(:args) { ['bar'] }
    version 'foo/bar/lib/bar'
    gemspec 'foo/bar/bar'
    run_cmd

    it { should output "Bumping bar from version 1.0.0 to 1.0.1" }
  end

  describe 'given --recurse' do
    let(:opts) { { recurse: true } }
    version 'foo/lib/foo', '1.0.0'
    gemspec 'foo/foo',     '1.0.0'
    version 'bar/lib/bar', '2.0.0'
    gemspec 'bar/bar',     '2.0.0'
    run_cmd

    it { should output "Bumping foo from version 1.0.0 to 1.0.1" }
    it { should output "Bumping bar from version 2.0.0 to 2.0.1" }
  end

  describe 'given a gem name ending in *_rb' do
    let(:args) { ['foo_rb'] }
    version 'lib/foo'
    gemspec 'foo_rb'
    run_cmd

    it { should output "Bumping foo_rb from version 1.0.0 to 1.0.1" }
  end

  describe 'given --version' do
    cwd     'foo-bar'
    version 'lib/foo/bar'
    run_cmd

    describe '1.2.3' do
      let(:opts) { { version: '1.2.3' } }
      it { should have_version 'foo/bar', '1.2.3' }
    end

    describe 'major' do
      let(:opts) { { version: :major } }
      it { should have_version 'foo/bar', '2.0.0' }
    end

    describe 'minor' do
      let(:opts) { { version: :minor } }
      it { should have_version 'foo/bar', '1.1.0' }
    end

    describe 'patch (default)' do
      it { should have_version 'foo/bar', '1.0.1' }
    end

    describe 'pre' do
      let(:opts) { { version: :pre } }
      it { should have_version 'foo/bar', '1.1.0.pre.1' }
    end
  end

  describe 'given --file lib/foo/bar/version.rb' do
    let(:opts) { { file: 'lib/foo/bar/version.rb' } }
    version 'lib/foo/bar'
    run_cmd

    it { should have_version 'lib/foo/bar', '1.0.1' }
  end

  describe 'given --skip-ci' do
    let(:opts) { { skip_ci: true } }
    version 'lib/tmp'
    run_cmd

    it { should run_cmd "git commit -m \"Bump tmp to 1.0.1 [skip ci]\"" }
  end


  describe 'given --branch' do
    let(:opts) { { branch: true } }
    version 'lib/tmp'
    run_cmd

    it { should output 'Checking out branch v1.0.1' }
    it { expect(cmds).to include 'git checkout -b v1.0.1' }
  end

  describe 'given --branch name' do
    let(:opts) { { branch: 'name' } }
    version 'lib/tmp'
    run_cmd

    it { should output 'Checking out branch name' }
    it { expect(cmds).to include 'git checkout -b name' }
  end

  describe 'given --no-commit' do
    let(:opts) { { commit: false } }
    version 'lib/tmp'
    run_cmd

    it { expect(out).to_not  include 'Creating commit' }
    it { expect(cmds).to_not include 'git commit -m "Bump tmp to 1.0.1"' }
  end

  describe 'given --sign' do
    let(:opts) { { sign: true } }
    version 'lib/tmp'
    run_cmd

    it { should run_cmd "git commit -m \"Bump tmp to 1.0.1\" -S" }
  end

  describe 'given --push' do
    let(:opts) { { push: true } }
    version 'lib/tmp'
    run_cmd

    it { should output 'Pushing to the origin git repository' }
    it { should run_cmd 'git push origin' }
  end

  describe 'given --remote foo' do
    let(:opts) { { push: true, remote: 'foo' } }
    version 'lib/tmp'
    remotes 'foo'
    run_cmd

    it { should output 'Pushing to the foo git repository' }
    it { should run_cmd 'git push foo' }
  end

  describe 'given --tag' do
    let(:opts) { { tag: true } }
    version 'lib/tmp'
    gemspec 'tmp', '1.0.1' # TODO make the gemspec load the version dynamically
    run_cmd

    it { should output 'Creating git tag v1.0.1' }
    it { should run_cmd 'git tag -am "tag v1.0.1" v1.0.1' }

    it { should_not output 'Pushing tags to the origin git repository' }
    it { should_not run_cmd 'git push --tags origin' }
  end

  describe 'given --tag and --push' do
    let(:opts) { { tag: true, push: true } }
    version 'lib/tmp'
    gemspec 'tmp', '1.0.1' # TODO make the gemspec load the version dynamically
    run_cmd

    it { should output 'Creating git tag v1.0.1' }
    it { should run_cmd 'git tag -am "tag v1.0.1" v1.0.1' }

    it { should output 'Pushing tags to the origin git repository' }
    it { should run_cmd 'git push --tags origin' }
  end

  describe 'given --release' do
    let(:opts) { { release: true } }
    version 'lib/tmp'
    gemspec 'tmp', '1.0.1' # TODO make the gemspec load the version dynamically
    run_cmd

    it { should run_cmd 'gem build tmp.gemspec' }
    it { should run_cmd 'gem push tmp-1.0.1.gem' }
  end

  describe 'given --quiet' do
    let(:opts) { { quiet: true } }
    version 'lib/tmp'
    run_cmd
    it { expect(out).to be_empty }
  end

  describe 'fails if there are uncommitted changes' do
    before { allow(git).to receive(:clean?).and_return(false) }
    it { expect { run }.to raise_error('Uncommitted changes found. Please commit or stash. Aborting.') }
  end

  describe 'stdout is not a tty (pipe attached)' do
    before { allow($stdout).to receive(:tty?).and_return false }

    cwd     'foo-bar'
    version 'lib/foo/bar'
    run_cmd

    it { should output 'bump foo-bar 1.0.0 1.0.1' }
    it { should output 'version lib/foo/bar/version.rb 1.0.0 1.0.1' }
    it { should output 'git_add lib/foo/bar/version.rb' }
    it { should output 'git_commit "Bump foo-bar to 1.0.1"' }

    it { should_not output '$ git add lib/foo/bar/version.rb' }
    it { should_not output 'All is good, thanks my friend.' }
  end
end
