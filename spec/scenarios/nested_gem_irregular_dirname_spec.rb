describe 'Scenario: Nested gem with conventional directory name' do
  let(:opts) { {} }

  run_cmd :bootstrap, ['sinja']
  cwd 'sinja/extensions'
  run_cmd :bootstrap, ['sinja-sequel']
  mv 'sinja-sequel', 'sequel'
  cwd '..'

  it { should have_file 'sinja.gemspec' }
  it { should have_file 'lib/sinja/version.rb' }

  it { should have_file 'extensions/sequel/sinja-sequel.gemspec' }
  it { should have_file 'extensions/sequel/lib/sinja/sequel/version.rb' }

  describe 'gem bump --recurse' do
    run_cmd :bump, [], recurse: true
    it { should have_version 'lib/sinja', '0.0.2' }
    it { should have_version 'extensions/sequel/lib/sinja/sequel', '0.0.2' }
  end

  describe 'gem bump' do
    run_cmd :bump, []
    it { should have_version 'lib/sinja', '0.0.2' }
    it { should have_version 'extensions/sequel/lib/sinja/sequel', '0.0.1' }
  end

  describe 'gem bump sinja' do
    run_cmd :bump, ['sinja']
    it { should have_version 'lib/sinja', '0.0.2' }
    it { should have_version 'extensions/sequel/lib/sinja/sequel', '0.0.1' }
  end

  describe 'gem bump sinja-sequel' do
    run_cmd :bump, ['sinja-sequel']
    it { should have_version 'lib/sinja', '0.0.1' }
    it { should have_version 'extensions/sequel/lib/sinja/sequel', '0.0.2' }
  end

  describe 'gem bump in sequel subdir' do
    cwd 'extensions/sequel'
    run_cmd :bump, []
    cwd '../..'
    it { should have_version 'lib/sinja', '0.0.1' }
    it { should have_version 'extensions/sequel/lib/sinja/sequel', '0.0.2' }
  end
end
