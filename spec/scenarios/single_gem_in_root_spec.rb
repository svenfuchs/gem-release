describe 'Single gem in root directory' do
  run_cmd :bootstrap, ['foo'], quiet: true
  cwd 'foo'

  it { should have_file 'foo.gemspec' }
  it { should have_file 'lib/foo/version.rb' }

  describe 'gem bump' do
    run_cmd :bump, [], quiet: true
    it { should have_version 'lib/foo', '0.0.2' }
  end

  describe 'gem bump foo' do
    run_cmd :bump, [], quiet: true
    it { should have_version 'lib/foo', '0.0.2' }
  end
end
