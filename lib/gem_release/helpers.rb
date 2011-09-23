require 'core_ext/string/camelize'

module GemRelease
  module Helpers
    def quiet?
      options[:quiet]
    end

    def user_name
      `git config --get user.name`.strip
    end

    def user_email
      `git config --get user.email`.strip
    end

    def github_user
      `git config --get github.user`.strip
    end

    def github_token
      `git config --get github.token`.strip
    end

    def gem_name
      gemspec ? gemspec.name : gem_name_from_directory
    end

    def gem_name_from_directory
      File.basename(Dir.pwd)
    end

    def gem_module_path
      gem_name.gsub('-', '_')
    end

    def gem_module_name
      gem_module_path.camelize
    end

    def gem_filename
      gemspec.file_name
    end

    def gem_version
      # After a version file has been changed, the new version will strangely not be obtained by reloading the spec with
      # Gem::Specification.load(). Therefore, let's obtain the version from the version file directly, and only use
      # gemspec.version if this fails.
      VersionFile.new.old_number
    rescue
      gemspec.version.to_s
    end

    def gemspec
      Gem::Specification.load(gemspec_filename)
    rescue LoadError, RuntimeError
      nil
    end

    def gemspec_filename
      name = Array(options[:args]).first rescue nil
      name ||= Dir['*.gemspec'].first
      name || raise("No gemspec found or given.")
    end

    def in_gemspec_dirs
      gemspec_dirs.each do |dir|
        Dir.chdir(dir) { yield }
      end
    end

    def gemspec_dirs
      Dir.glob('**/*.gemspec').map { |spec| File.dirname(spec) }
    end
  end
end
