module GemRelease
  module Helpers
    def gem_filename
      gemspec.file_name
    end
    
    def gem_version
      gemspec.version.to_s
    end
    
    def gemspec
      @gemspec ||= Gem::Specification.load(gemspec_filename)
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