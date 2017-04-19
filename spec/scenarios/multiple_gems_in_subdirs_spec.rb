describe 'Scenario: Multiple gems in sub directories' do
  let(:opts) { {} }

  cwd 'root'
  run_cmd :bootstrap, ['foo']
  run_cmd :bootstrap, ['bar']

  it { should have_file 'foo/foo.gemspec' }
  it { should have_file 'foo/lib/foo/version.rb' }

  it { should have_file 'bar/bar.gemspec' }
  it { should have_file 'bar/lib/bar/version.rb' }

  describe 'gem bump --recurse' do
    run_cmd :bump, [], recurse: true
    it { should have_version 'foo/lib/foo', '0.0.2' }
    it { should have_version 'bar/lib/bar', '0.0.2' }
  end

  describe 'gem bump' do
    run_cmd :bump, []
    it { should have_version 'foo/lib/foo', '0.0.2' }
    it { should have_version 'bar/lib/bar', '0.0.2' }
  end

  describe 'gem bump foo bar' do
    run_cmd :bump, ['foo', 'bar']
    it { should have_version 'foo/lib/foo', '0.0.2' }
    it { should have_version 'bar/lib/bar', '0.0.2' }
  end

  describe 'gem bump foo' do
    run_cmd :bump, ['foo']
    it { should have_version 'foo/lib/foo', '0.0.2' }
    it { should have_version 'bar/lib/bar', '0.0.1' }
  end

  describe 'gem bump bar' do
    run_cmd :bump, ['bar']
    it { should have_version 'foo/lib/foo', '0.0.1' }
    it { should have_version 'bar/lib/bar', '0.0.2' }
  end
end
