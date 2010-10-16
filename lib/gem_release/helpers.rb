require 'core_ext/string/camelize'

module GemRelease
  module Helpers
    def user_name
      `git config --get user.name`.strip
    end

    def user_email
      `git config --get user.email`.strip
    end

    def github_user
      @github_user ||= `git config --get github.user`.strip
    end

    def github_token
      @github_token ||= `git config --get github.token`.strip
    end

    def gem_name
      @gem_name ||= gemspec ? gemspec.name : gem_name_from_directory
    end

    def gem_name_from_directory
      File.basename(Dir.pwd)
    end

    def gem_module_path
      @gem_module_path ||= gem_name.gsub('-', '_')
    end

    def gem_module_name
      @gem_module_name ||= gem_module_path.camelize
    end

    def gem_filename
      gemspec.file_name
    end

    def gem_version
      gemspec.version.to_s
    end

    def gemspec
      @gemspec ||= Gem::Specification.load(gemspec_filename)
    rescue LoadError, RuntimeError
      nil
    end

    def gemspec_filename
      @gemspec_filename ||= begin
        name = Array(options[:args]).first rescue nil
        name ||= Dir['*.gemspec'].first
        name || raise("No gemspec found or given.")
      end
    end
  end
end
