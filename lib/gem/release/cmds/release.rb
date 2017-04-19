require 'gem/release/cmds/base'
require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'

module Gem
  module Release
    module Cmds
      class Release < Base
        summary 'Releases one or all gems in this directory.'

        description <<~str
          Builds one or many gems from the given gemspec(s), pushes them to rubygems.org
          (or another, compatible host), and removes the left over gem file.

          Optionally invoke `gem tag`.

          If no argument is given the first gemspec's name is assumed as the gem name.
          If one or many arguments are given then these will be used. If `--recurse` is
          given then all gem names from all gemspecs in this directory or any of its
          subdirectories will be used.
        str

        arg :gem_name, 'name of the gem (optional, will use the first gemspec, or all gemspecs if --recurse is given)'

        DESCR = {
          host:    'Push to a compatible host other than rubygems.org',
          key:     'Use the API key from ~/.gem/credentials',
          tag:     'Shortcut for running the `gem tag` command',
          recurse: 'Recurse into directories that contain gemspec files'
        }

        opt '-h', '--host HOST', DESCR[:host] do |value|
          opts[:host] = value
        end

        opt '-k', '--key KEY', DESCR[:key] do |value|
          opts[:key] = value
        end

        opt '-t', '--tag', DESCR[:tag] do |value|
          opts[:tag] = value
        end

        opt '--recurse', DESCR[:recurse] do |value|
          opts[:recurse] = value
        end

        MSGS = {
          release: 'Releasing %s with version %s',
          build:   'Building %s',
          push:    'Pushing %s',
          cleanup: 'Deleting left over gem file %s'
        }

        CMDS = {
          cleanup: 'rm -f %s'
        }

        def run
          in_gem_dirs do
            release
          end
          tag if opts[:tag]
        end

        private

          def release
            announce :release, gem.name, gem.version
            build
            push
          ensure
            cleanup
          end

          def tag
            Tag.new(context, args, opts).run
          end

          def build
            gem_cmd :build, gem.spec_filename
          end

          def push
            gem_cmd :push, gem.filename, *push_args
          end

          def push_args
            args = [:key, :host].map { |opt| ["--#{opt}", opts[opt]] if opts[opt] }
            args << "--quiet" if quiet?
            args.compact.flatten
          end

          def cleanup
            cmd :cleanup, gem.filename
          end
      end
    end
  end
end
