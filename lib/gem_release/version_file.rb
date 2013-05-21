require 'core_ext/kernel/silence'

module GemRelease
  class VersionFile
    include GemRelease::Helpers

    VERSION_PATTERN = /(VERSION\s*=\s*(?:"|'))((?:(?!"|').)*)("|')/
    NUMBER_PATTERN  = /(\d+)\.(\d+)\.(\d+)(.*)/
    PRERELEASE_NUMBER_PATTERN  = /(\d+)\.(\d+)\.(\d+)\.(.*)(\d+)/

    attr_reader :target

    def initialize(options = {})
      @target = options[:target]
      if @target == nil || @target == ''
        @target = is_prerelease_version_number?(old_number) ? :pre : :patch
      elsif @target.to_sym == :release
        @target = :patch unless is_prerelease_version_number?(old_number)
      end
    end

    def bump!
      File.open(filename, 'w+') { |f| f.write(bumped_content) }
      reload_version
    end

    def new_number
      @new_number ||=
        if is_version_number?(target)
          target
        elsif [:major, :minor, :patch].include?(target.to_sym)
          old_number.sub(NUMBER_PATTERN) do
            send(target, $1, $2, $3)
          end
        elsif is_prerelease_version_number?(old_number)
          old_number.sub(PRERELEASE_NUMBER_PATTERN) do
            (target.to_sym == :release) ? release($1, $2, $3) : prerelease($1, $2, $3, $4, $5)
          end
        else
          old_number.sub(NUMBER_PATTERN) do
            "#{patch($1, $2, $3)}.#{target}1"
          end
        end
    end

    def old_number
      @old_number ||= content =~ VERSION_PATTERN && $2
    end

    def filename
      path = gem_name
      path = path.gsub('-', '/') unless File.exists?(path_to_version_file(path))
      path = path.gsub('/', '_') unless File.exists?(path_to_version_file(path))

      File.expand_path(path_to_version_file(path))
    end

    protected

      def path_to_version_file(path)
        "lib/#{path}/version.rb"
      end

      def reload_version
        silently { load(filename) }
      end

      def major(major, minor, patch)
        "#{major.to_i + 1}.0.0"
      end

      def minor(major, minor, patch)
        "#{major}.#{minor.to_i + 1}.0"
      end

      def patch(major, minor, patch)
        "#{major}.#{minor}.#{patch.to_i + 1}"
      end

      def release(major, minor, patch)
        "#{major}.#{minor}.#{patch}"
      end

      def prerelease(major, minor, patch, prereleasePrefix, prereleaseNumber)
        "#{major}.#{minor}.#{patch}.#{prereleasePrefix || 'pre'}#{prereleaseNumber.to_i + 1}"
      end

      def content
        @content ||= File.read(filename)
      end

      def bumped_content
        content.sub(VERSION_PATTERN) { "#{$1}#{new_number}#{$3}" }
      end

      def silently(&block)
        warn_level = $VERBOSE
        $VERBOSE = nil
        begin
          result = block.call
        ensure
          $VERBOSE = warn_level
        end
        result
      end

      def is_version_number?(v)
        v.to_s.match(NUMBER_PATTERN) != nil
      end

      def is_prerelease_version_number?(v)
        v.to_s.match(PRERELEASE_NUMBER_PATTERN) != nil
      end
  end
end
