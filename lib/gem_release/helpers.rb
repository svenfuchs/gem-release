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

    def gem_filename
      gemspec.file_name
    end

    def gem_version
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

    def in_bootstrapped_dir
      dir = Array(options[:args]).first rescue nil
      if dir && dir.kind_of?(String) && dir[0] != '-'
        Dir.mkdir dir
        Dir.chdir(dir) { yield }
      else
        yield
      end
    end

    def reset_gemspec_cache
      # Gemspecs are cached in rubygems >= 2.1, so we need to clear the cache
      # in case gem versions have changed.
      #
      # Note: This is not needed or supported with older rubygems, which is
      # why exceptions are swallowed.
      begin
        Gem::Specification.reset
      rescue
      end
    end

    def run_cmd(command)
      reset_gemspec_cache

      unless send(command)
        say "The task `#{command}` could not be completed. Subsequent tasks will not be attempted."
        abort
      end
    end

    def success
      unless quiet? || options[:quiet_success]
        say "All is good, thanks my friend.\n"
      end
    end
  end
end
