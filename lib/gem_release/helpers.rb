require 'core_ext/kernel/silence'

module GemRelease
  module Helpers
    def github_user
      @github_user ||= `git config --get github.user`.strip
    end
  
    def github_token
      @github_token ||= `git config --get github.token`.strip
    end
  
    def gem_name
      @gem_name ||= gemspec ? gemspec.name : File.basename(Dir.pwd)
    end
  
    def gem_filename
      gemspec.file_name
    end
    
    def gem_version
      gemspec.version.to_s
    end
    
    def gemspec
      @gemspec ||= silence { Gem::Specification.load(gemspec_filename) }
    rescue LoadError, RuntimeError
      nil
    end

    def gemspec_filename
      @gemspec_filename ||= begin
        name = Array(options[:args]).first
        name ||= Dir['*.gemspec'].first
        name || raise("No gemspec found or given.")
      end
    end
  end
end