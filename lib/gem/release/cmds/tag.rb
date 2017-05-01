require 'gem/release/cmds/base'

module Gem
  module Release
    module Cmds
      class Tag < Base
        summary "Tags the HEAD commit with the gem's current version."

        description <<~str
          Creates an annotated tag for the current HEAD commit, using the gem's
          current version.

          Optionally pushes the tag to the origin repository.

          If one or many arguments are given then gemspecs with the same names
          will be searched, and the working directory changed to their respective
          directories. If `--recurse` is given then the directories all gem names from
          all gemspecs in this directory or any of its subdirectories will be used.
          This assumes that these directories are separate git repositories.

          The tag name will be `v[version]`.  For example, if the current version is
          `1.0.0`, then The tag is created using the command `git tag -am "tag v1.0.0"
          v1.0.0`.
        str

        DEFAULTS = {
          push: true,
          remote: 'origin'
        }

        DESCR = {
          push:    'Push tag to the remote git repository',
          remote:  'Git remote to push to (defaults to origin)',
          sign:    'GPG sign the tag',
        }

        opt '-p', '--[no]-push', DESCR[:push] do
          opts[:push] = true
        end

        opt '--remote REMOTE', DESCR[:remote] do |value|
          opts[:remote] = value
        end

        MSGS = {
          tag:       'Tagging %s as version %s',
          git_tag:   'Creating git tag %s',
          git_push:  'Pushing tags to the %s git repository',
          no_remote: 'Cannot push to missing git remote %s',
          git_dirty: 'Uncommitted changes found. Please commit or stash.',
        }

        CMDS = {
          git_tag:   'git tag -am "tag %s" %s %s',
          git_push:  'git push --tags %s'
        }

        def run
          in_gem_dirs do
            announce :tag, gem.name, gem.version
            validate
            tag
            push if opts[:push]
          end
        end

        private

          def validate
            abort :git_dirty unless git_clean?
            abort :no_remote, remote if push? && !git_remotes.include?(remote)
          end

          def tag
            cmd :git_tag, tag_name, tag_name, opts[:sign] ? '--sign' : ''
          end

          def push
            cmd :git_push, remote
          end

          def tag_name
            "v#{gem.version}"
          end

          def push?
            opts[:push] || opts[:push_commit]
          end

          def remote
            opts[:remote]
          end
      end
    end
  end
end
