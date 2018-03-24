describe Gem::Release::Cmds::Github do
  let(:args)   { [] }
  let(:opts)   { { repo: 'foo/bar', token: 'token' } }
  let(:body)   { '{"tag_name":"v1.0.0","name":"foo-bar v1.0.0","body":null,"prerelease":false}' }
  let(:status) { 200 }

  cwd 'foo-bar'
  gemspec 'foo-bar'

  before { context.git.tags << 'v1.0.0' }
  before { stub_request(:post, 'http://api.github.com:443/repos/foo/bar/releases').with(body: body).to_return(status: status) }

  describe 'by default' do
    run_cmd

    it { should_not run_cmd 'git push --tags origin' }
    it { should output  'Creating GitHub release for foo-bar version v1.0.0' }
    it { should output 'All is good, thanks my friend.' }
  end

  describe 'not tagged' do
    before { context.git.tags.clear }
    it { expect { run }.to raise_error('Tag v1.0.0 does not exist. Run `gem tag` or pass `--tag`. Aborting.') }
  end

  describe 'invalid token' do
    let(:status) { 401 }
    it { expect { run }.to raise_error('GitHub returned 401 (body: "")') }
  end

  describe 'not found' do
    let(:status) { 404 }
    it { expect { run }.to raise_error('GitHub returned 404 (body: "")') }
  end
end
