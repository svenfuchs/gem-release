describe Gem::Release::Cmds::Gemspec do
  let(:args) { [] }
  let(:opts) { {} }
  let(:spec) { File.read('foo-bar.gemspec') }

  cwd 'foo-bar'

  describe 'generates a gemspec' do
    run_cmd

    it { should output 'Generating foo-bar.gemspec' }

    it { expect(spec).to include "require 'foo/bar/version'" }

    it { expect(spec).to specify :name,        'foo-bar' }
    it { expect(spec).to specify :version,     'Foo::Bar::VERSION' }
    it { expect(spec).to specify :authors,     'Sven Fuchs' }
    it { expect(spec).to specify :email,       'me@svenfuchs.com' }
    it { expect(spec).to specify :homepage,    'https://github.com/svenfuchs/foo-bar' }
    it { expect(spec).to specify :summary,     '[summary]' }
    it { expect(spec).to specify :description, '[description]' }
  end

  describe 'given two gem names' do
    let(:args) { ['foo', 'bar'] }

    run_cmd

    context do
      cwd 'foo'
      it { should output 'Generating foo.gemspec' }
      it { expect(File.file?('foo.gemspec')).to be true }
    end

    context do
      cwd 'bar'
      it { should output 'Generating bar.gemspec' }
      it { expect(File.file?('bar.gemspec')).to be true }
    end
  end

  describe 'given a custom template' do
    file '~/.gem-release/default/gemspec', 'custom gemspec'
    run_cmd
    it { expect(spec).to eq 'custom gemspec' }
  end

  describe 'the gemspec exists' do
    gemspec 'foo-bar'
    run_cmd
    it { should output 'Skipping foo-bar.gemspec: already exists' }
  end

  describe 'strategy' do
    run_cmd

    describe 'default (glob)' do
      it { expect(spec).to specify :files, '{bin/*,lib/**/*,[A-Z]*}' }
    end

    describe 'given --strategy git' do
      let(:opts) { { strategy: :git } }
      it { expect(spec).to specify :files, 'git ls-files app lib' }
    end
  end

  describe 'bin files' do
    describe 'given --bin' do
      run_cmd

      describe 'default (glob)' do
        let(:opts) { { bin: true } }
        it { expect(spec).to specify :executables, "Dir.glob('bin/*')" }
      end

      describe 'given --strategy git' do
        let(:opts) { { bin: true, strategy: :git } }
        it { expect(spec).to specify :executables, '`git ls-files bin`' }
      end
    end

    describe 'given a directory ./bin' do
      file './bin/foo'
      run_cmd

      describe 'default (glob)' do
        it { expect(spec).to specify :executables, "Dir.glob('bin/*')" }
      end

      describe 'given --strategy git' do
        let(:opts) { { strategy: :git } }
        it { expect(spec).to specify :executables, '`git ls-files bin`' }
      end
    end

    describe 'given --no-bin and a directory ./bin' do
      file './bin/foo'
      run_cmd

      describe 'default (glob)' do
        let(:opts) { { bin: false } }
        it { expect(spec).to_not specify :executables }
      end

      describe 'given --strategy git' do
        let(:opts) { { bin: false, strategy: :git } }
        it { expect(spec).to_not specify :executables }
      end
    end

  end

  describe 'license' do
    run_cmd

    describe 'defaults to MIT' do
      let(:opts) { { license: [:mit] } }
      it { expect(spec).to specify :licenses, 'MIT' }
    end

    describe 'given --no-license' do
      let(:opts) { { license: false } }
      it { expect(spec).to specify :licenses, '[]' }
    end

    describe 'given --license MIT --license MPL-v2' do
      let(:opts) { { license: ['mit', 'mpl-v2'] } }
      it { expect(spec).to specify :licenses, "['MIT', 'MPL-V2']" }
    end

    describe 'given --license MIT,MPL-v2' do
      let(:opts) { { license: ['mit,mpl-v2'] } }
      it { expect(spec).to specify :licenses, "['MIT', 'MPL-V2']" }
    end
  end

  describe 'given --quiet' do
    let(:opts) { { quiet: true } }
    run_cmd
    it { expect(out).to be_empty }
  end
end
