module Gem
  module Release
    class Context
      class Gemspec < Struct.new(:name)
        attr_reader :filename

        def initialize(*)
          super
          @filename = name && "#{name}.gemspec" || filenames.first
        end

        def gem_name
          gemspec.name if gemspec
        end

        def version
          gemspec.version.to_s if gemspec
        end

        def gem_filename
          gemspec.file_name if gemspec
        end

        def exists?
          filename && File.exists?(filename)
        end

        private

          def gemspec
            return @gemspec if instance_variable_defined?(:@gemspec)
            @gemspec = exists? ? ::Gem::Specification.load(filename) : nil
          end

          def filenames
            Dir['*.gemspec'].map { |path| File.basename(path) }
          end
      end
    end
  end
end
