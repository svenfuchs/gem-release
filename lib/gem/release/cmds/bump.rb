require 'gem/release/cmds/base'
require 'gem/release/files/version'

module Gem
  module Release
    module Cmds
      class Bump < Base
        summary 'Bumps one, several, or all gems in this directory.'

        description <<~str
          Bumps the version number defined in lib/[gem_name]/version.rb to to a given,
          specific version number, or to the next major, minor, patch, or pre-release
          level.

          Optionally it pushes to the origin repository. Also, optionally it invokes the
          `gem tag` and/or `gem release` command.

          If no argument is given the first gemspec's name is assumed as the gem name.
          If one or many arguments are given then these will be used as gem names. If
          `--recurse` is given then all gem names from all gemspecs in this directory or
          any of its subdirectories will be used.

          The version can be bumped to either one of these targets:

          ```
          major
          1.1.1       # Bump to the given, specific version number
          major       # Bump to the next major level (e.g. 0.0.1 to 1.0.0)
          minor       # Bump to the next minor level (e.g. 0.0.1 to 0.1.0)
          patch       # Bump to the next patch level (e.g. 0.0.1 to 0.0.2)
          pre|rc|etc  # Bump to the next pre-release level (e.g. 0.0.1 to
                      #   0.1.0.pre.1, 1.0.0.pre.1 to 1.0.0.pre.2)
          ```

          When searching for the version file for a gem named `gem-name`: the following
          paths will be searched relative to the gemspec's directory.

          * `lib/gem-name/version.rb`
          * `lib/gem/name/version.rb`
        str

        arg :gem_name, 'name of the gem (optional, will use the directory name, or all gemspecs if --recurse is given)'

        DESCR = {
          version: 'Target version: next [major|minor|patch|pre|release] or a given version number [x.x.x]',
          commit:  'Perform a commit after incrementing gem version',
          push:    'Push the new commit to the git remote repository',
          remote:  'Git remote to push to (defaults to origin)',
          tag:     'Shortcut for running the `gem tag` command',
          recurse: 'Recurse into directories that contain gemspec files',
          release: 'Shortcut for the `gem release` command'
        }

        DEFAULTS = {
          commit: true,
          push:   false,
          remote: 'origin'
        }

        opt '-c', '--[no-]commit', DESCR[:commit] do |value|
          opts[:commit] = value
        end

        opt '-p', '--[no-]push', DESCR[:push] do |value|
          opts[:push] = value
        end

        opt '--remote REMOTE', DESCR[:remote] do |value|
          opts[:remote] = value
        end

        opt '-v', '--version VERSION', DESCR[:version] do |value|
          opts[:version] = value
        end

        opt '-t', '--tag', DESCR[:tag] do |value|
          opts[:tag] = value
        end

        opt '-r', '--release', DESCR[:release] do |value|
          opts[:release] = value
        end

        opt '--recurse', DESCR[:recurse] do |value|
          opts[:recurse] = value
        end

        MSGS = {
          bump:          'Bumping %s from version %s to %s',
          version:       'Changing version in %s from %s to %s',
          git_add:       'Staging %s',
          git_commit:    'Creating commit',
          git_push:      'Pushing to the %s git repository',
          git_dirty:     'Uncommitted changes found. Please commit or stash.',
          not_found:     'Ignoring %s. Version file %s not found.',
          no_git_remote: 'Cannot push to missing git remote %s.'
        }

        CMDS = {
          git_add:    'git add %s',
          git_commit: 'git commit -m "Bump to %s"',
          git_push:   'git push %s'
        }

        def run
          in_gem_dirs do
            validate
            bump
            commit  if opts[:commit]
            push    if opts[:commit] && opts[:push]
            reset
          end
          tag     if opts[:tag]
          release if opts[:release]
        end

        private

          def validate
            abort :git_dirty unless git_clean?
            abort :not_found, gem.name, version.path || '?' unless version.exists?
            abort :no_git_remote, remote if push? && !git_remotes.include?(remote.to_s)
          end

          def bump
            announce :bump, gem.name, version.from, version.to
            return true if pretend?
            notice :version, version.path, version.from, version.to
            version.bump
          end

          def commit
            cmd :git_add, version.path
            cmd :git_commit, version.to
          end

          def push
            cmd :git_push, remote
          end

          def tag
            Tag.new(context, args, opts).run
          end

          def release
            Release.new(context, args, except(opts, :tag)).run
          end

          def reset
            @version = nil
          end

          def version
            @version ||= Files::Version.new(gem.name, opts[:version])
          end

          def push?
            opts[:push]
          end

          def remote
            opts[:remote]
          end
      end
    end
  end
end
