require_relative '../version/number'

module Gem
  module Release
    module Files
      class Version < Struct.new(:name, :version, :opts)
        VERSION      = /(VERSION\s*=\s*(?:"|'))((?:(?!"|').)*)("|')/

        # Note from implementing Epoch versioning:
        # The RELEASE+PRE_RELEASE+STAGES constants were already here but appear to be unused.
        # As a first time contributor, I figured it would be safer to leave them in place.
        # I have added EPOCH_RELEASE and EPOCH_PRE_RELEASE just to keep things consistent.
        EPOCH_PREFIX  = /^(?<epoch>\d+)\./
        SEMVER        = /(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/
        STAGE         = /\.?(?<stage>.*)(?<stage_num>\d+)/
        RELEASE       = /^#{SEMVER}(.*)$/
        PRE_RELEASE   = /^#{SEMVER}$#{STAGE}/
        EPOCH_RELEASE = /#{EPOCH_PREFIX}#{SEMVER}(.*)$/
        EPOCH_PRE_RELEASE = /#{EPOCH_PREFIX}#{SEMVER}$#{STAGE}/
        STAGES = [:epoch, :major, :minor, :patch]

        def exists?
          !!path
        end

        def bump
          File.write(path, bumped)
        end

        def path
          @path ||= opts[:file] || paths.detect { |path| File.exist?(path) }
        end

        def from
          @from ||= content =~ VERSION && $2 || raise("Could not determine current version from file #{path}")
        end

        def to
          @to ||= number.bump
        end

        def to_h
          { from: from, version: to }
        end

        private

          def paths
            %W(
              lib/#{name.gsub('-', '/')}/version.rb
              lib/#{name}/version.rb
            ).uniq
          end

          def not_found
            raise Abort, "version.rb file not found (#{paths.join(', ')})"
          end

          def number
            @number ||= Release::Version::Number.new(from, version ? version.to_sym : nil)
          end

          def bumped
            content.sub(VERSION) { "#{$1}#{to}#{$3}" }
          end

          def content
            @content ||= File.read(path) if exists?
          end

          def to_num(*args)
            args.join('.')
          end

          def path_to(path)
            "lib/#{path}/version.rb"
          end

          def name
            @name ||= super.sub(/_rb$/, '')
          end
      end
    end
  end
end
