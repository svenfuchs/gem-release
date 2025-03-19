require 'fileutils'

module Support
  module Files
    class << self
      CWD  = Dir.pwd
      HOME = File.expand_path('tmp/home')

      def included(c)
        ENV['HOME'] = HOME

        c.send(:extend, ClassMethods)
        c.before { Files.setup }
        c.after  { Files.teardown }
      end

      def setup
        FileUtils.mkdir_p(HOME)
        Dir.chdir('tmp')
      end

      def teardown
        Dir.chdir(CWD)
        FileUtils.rm_rf('tmp')
      end
    end

    module ClassMethods
      def cwd(path)
        dir(path)
        before { Dir.chdir(File.expand_path(path)) }
      end

      def dir(path)
        before { FileUtils.mkdir_p(File.expand_path(path)) }
        after  { FileUtils.rm_rf(File.expand_path(path)) unless path.include?('.') }
      end

      def file(path, content = '')
        before { write(File.expand_path(path), content) }
        after  { FileUtils.rm(File.expand_path(path)) }
      end

      def mv(from, to)
        before { FileUtils.mv(File.expand_path(from), File.expand_path(to)) }
      end

      def rm(path)
        before { FileUtils.rm_rf(File.expand_path(path)) if File.expand_path(path) != '/' }
      end

      def gemspec(path, version = '1.0.0')
        name = File.basename(path)
        file "#{path}.gemspec", "Gem::Specification.new { |s| s.name = '#{name}'; s.version = '#{version}' }"
      end

      def version(path, version = '1.0.0')
        # path = "lib/#{path}" unless path.include?('lib')
        file "#{path.gsub('-', '/')}/version.rb", "VERSION = '#{version}'"
      end
    end

    def write(path, content)
      path = File.expand_path(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, content)
    end
  end
end
