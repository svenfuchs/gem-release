describe 'Scenario: Multiple gems in root directory' do
  run_cmd :bootstrap, ['foo'], quiet: true
  cwd 'foo'
  run_cmd :bootstrap, ['bar'], quiet: true, dir: '.'

  it { should have_file 'foo.gemspec' }
  it { should have_file 'lib/foo/version.rb' }

  it { should have_file 'bar.gemspec' }
  it { should have_file 'lib/bar/version.rb' }

  describe 'gem bump bumps bar (because this is the first gemspec found)' do
    run_cmd :bump, [], quiet: true
    it { should have_version 'lib/foo', '0.0.1' }
    it { should have_version 'lib/bar', '0.0.2' }
  end

  describe 'gem bump foo' do
    run_cmd :bump, ['foo'], quiet: true
    it { should have_version 'lib/foo', '0.0.2' }
    it { should have_version 'lib/bar', '0.0.1' }
  end

  describe 'gem bump bar' do
    run_cmd :bump, ['bar'], quiet: true
    it { should have_version 'lib/foo', '0.0.1' }
    it { should have_version 'lib/bar', '0.0.2' }
  end
end
