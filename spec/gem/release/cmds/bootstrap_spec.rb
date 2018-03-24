describe Gem::Release::Cmds::Bootstrap do
  let(:args) { [] }
  let(:opts) { {} }

  shared_examples_for 'scaffolds default files' do |name|
    files = %W(
      .gitignore
      Gemfile
      #{name}.gemspec
      LICENSE.md
      lib/#{name.sub('-', '/')}.rb
      lib/#{name.sub('-', '/')}/version.rb
    )
    files.each do |file|
      it { should output "Creating #{file}" }
      it { should have_file file }
    end
  end

  describe 'by default' do
    cwd 'foo-bar'
    run_cmd

    include_examples 'scaffolds default files', 'foo-bar'
    it { should output 'All is good, thanks my friend.' }
  end

  describe 'given a file already exists' do
    file '.gitignore', 'exists'
    run_cmd

    it { should output "Skipping existing file .gitignore" }
    it { expect(File.read('.gitignore')).to eq 'exists' }
  end

  describe 'given two gem names' do
    let(:args) { ['foo', 'bar'] }
    run_cmd

    context do
      cwd 'foo'
      include_examples 'scaffolds default files', 'foo'
    end

    context do
      cwd 'bar'
      include_examples 'scaffolds default files', 'bar'
    end
  end

  describe 'given a gem name ending in *_rb' do
    let(:args) { ['foo_rb'] }
    run_cmd
    cwd 'foo_rb'

    it { should have_file 'lib/foo.rb' }
    it { should have_file 'lib/foo/version.rb' }
  end

  describe 'standard templates' do
    describe 'in ./.gem-release/default' do
      file './.gem-release/default/.gitignore', 'gitignore'
      run_cmd

      it { should have_file '.gitignore', 'gitignore' }
    end

    describe 'in ~/.gem-release/default' do
      file '~/.gem-release/default/.gitignore', '.gitignore'
      run_cmd

      it { should have_file '.gitignore', 'gitignore' }
    end

    describe 'in both ./.gem-release/default and ~/.gem-release/default' do
      file './.gem-release/default/.gitignore', 'local'
      file '~/.gem-release/default/.gitignore', 'global'
      run_cmd

      it { should have_file '.gitignore', 'local' }
    end
  end

  describe 'custom templates' do
    describe 'in ./.gem-release/default' do
      file './.gem-release/default/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
    end

    describe 'in ~/.gem-release/default' do
      file '~/.gem-release/default/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
    end

    describe 'in both ./.gem-release/default and ~/.gem-release/default' do
      file './.gem-release/default/foo', 'foo'
      file '~/.gem-release/default/bar', 'bar'
      run_cmd

      it { should have_file 'foo' }
      it { should_not have_file 'bar' }
    end
  end

  describe 'given --bin' do
    cwd 'foo-bar'
    let(:opts) { { bin: true } }
    let(:spec) { File.read('foo-bar.gemspec') }

    describe 'by default' do
      run_cmd

      it { should have_file 'bin/foo-bar', '#!/usr/bin/env ruby' }
    end

    describe 'with custom template ./.gem-release/executable' do
      file './.gem-release/executable', 'foo'
      run_cmd

      it { should have_file 'bin/foo-bar', 'foo' }
      it { expect(spec).to specify :executables, "Dir.glob('bin/*')" }
    end

    describe 'with custom template ~/.gem-release/executable' do
      file '~/.gem-release/executable', 'foo'
      run_cmd

      it { should have_file 'bin/foo-bar', 'foo' }
      it { expect(spec).to specify :executables, "Dir.glob('bin/*')" }
    end
  end

  describe 'given --rspec' do
    let(:opts) { { rspec: true } }

    describe 'by default' do
      run_cmd

      it { should have_file '.rspec', '--color' }
      it { should have_file 'spec/spec_helper.rb' }
    end

    describe 'with custom templates in ./.gem-release/rspec' do
      file './.gem-release/rspec/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
      it { should_not have_file '.rspec' }
    end

    describe 'with custom templates in ~/.gem-release/rspec' do
      file '~/.gem-release/rspec/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
      it { should_not have_file '.rspec' }
    end
  end

  describe 'given --travis' do
    let(:opts) { { travis: true } }

    describe 'by default' do
      run_cmd

      it { should have_file '.travis.yml' }
    end

    describe 'with custom templates in ./.gem-release/travis' do
      file './.gem-release/travis/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
      it { should_not have_file '.travis.yml' }
    end

    describe 'with custom templates in ~/.gem-release/travis' do
      file '~/.gem-release/travis/foo', 'foo'
      run_cmd

      it { should have_file 'foo' }
      it { should_not have_file '.travis.yml' }
    end
  end

  describe 'gemspec files strategy' do
    run_cmd

    describe 'by default' do
      it { should have_file 'tmp.gemspec', '{bin/*,lib/**/*,[A-Z]*}' }
    end

    describe 'given --strategy git' do
      let(:opts) { { strategy: :git } }
      it { should have_file 'tmp.gemspec', 'git ls-files app lib' }
    end
  end

  describe 'license' do
    let(:spec) { File.read('tmp.gemspec') }

    describe 'by default' do
      run_cmd
      it { should have_file 'LICENSE.md', 'MIT LICENSE' }
      it { expect(spec).to specify :licenses, 'MIT' }
    end

    describe 'given --no-license' do
      let(:opts) { { license: [] } }
      run_cmd
      it { should_not have_file 'LICENSE.md' }
      it { expect(spec).to specify :licenses, '[]' }
    end

    describe 'given --license mpl-2' do
      let(:opts) { { license: 'mpl-2' } }
      run_cmd
      it { should have_file 'LICENSE.md', 'Mozilla Public License Version 2.0' }
      it { expect(spec).to specify :licenses, 'MPL-2' }
    end

    describe 'given --license foo' do
      let(:opts) { { license: :foo } }

      describe 'by default' do
        run_cmd
        it { should output 'Unknown license: foo' }
        it { should_not have_file 'LICENSE.md' }
        it { expect(spec).to specify :licenses, 'FOO' }
      end

      describe 'given ./.gem-release/licenses/foo.txt exists' do
        file './.gem-release/licenses/foo.txt', 'foo'
        run_cmd
        it { should have_file 'LICENSE.txt', 'foo' }
        it { expect(spec).to specify :licenses, 'FOO' }
      end

      describe 'given ~/.gem-release/licenses/foo exists' do
        file '~/.gem-release/licenses/foo', 'foo'
        run_cmd
        it { should have_file 'LICENSE', 'foo' }
        it { expect(spec).to specify :licenses, 'FOO' }
      end
    end
  end

  describe 'given --git' do
    let(:opts) { { git: true } }
    run_cmd

    it { should output 'Initializing git repository' }
    it { should run_cmd('git init') }
  end

  describe 'given --github' do
    let(:opts) { { github: true } }
    run_cmd

    it { should output 'Initializing git repository' }
    it { should run_cmd('git init') }
    it { should output 'Adding files' }
    it { should run_cmd('git add .') }

    describe 'by default' do
      it { should output 'Adding git remote origin' }
      it { should run_cmd 'git remote add origin https://github.com/svenfuchs/tmp.git' }
      it { should_not output 'Pushing to git remote origin' }
      it { should_not run_cmd 'git push -u origin master' }
    end

    describe 'given --push' do
      let(:opts) { { github: true, push: true } }
      it { should output 'Pushing to git remote origin' }
      it { should run_cmd 'git push -u origin master' }
    end

    describe 'given --remote foo' do
      let(:opts) { { github: true, remote: :foo } }
      it { should output 'Adding git remote foo' }
      it { should run_cmd 'git remote add foo https://github.com/svenfuchs/tmp.git' }
    end

    describe 'given --push --remote foo' do
      let(:opts) { { github: true, remote: :foo, push: true } }
      it { should output 'Pushing to git remote foo' }
      it { should run_cmd 'git push -u foo master' }
    end
  end

  describe 'given --quiet' do
    let(:opts) { { quiet: true } }
    cwd 'foo-bar'
    run_cmd
    it { expect(out).to be_empty }
  end
end
