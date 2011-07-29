require 'erb'
require 'fileutils'
require 'core_ext/string/camelize'

module GemRelease
  class Template
    include GemRelease::Helpers

    attr_reader :template, :name, :module_name, :module_path

    def initialize(template, options = {})
      @template = template

      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
        meta_class.send(:attr_reader, key)
      end

      @name        ||= gem_name_from_directory
      @module_path ||= name.gsub('-', '_')
      @module_name ||= module_path.camelize
    end

    def write
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, 'w+') { |f| f.write(render) }
    end

    def filename
      template
    end

    protected

      def render
        ERB.new(read_template, nil, "%").result(binding)
      end

      def read_template
        File.new(File.expand_path("../templates/#{template}", __FILE__)).read
      end

      def meta_class
        class << self; self; end
      end
  end
end
