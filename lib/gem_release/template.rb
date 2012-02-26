require 'erb'
require 'fileutils'
require 'core_ext/string/camelize'

module GemRelease
  class Template
    include GemRelease::Helpers

    attr_reader :template, :filename, :name, :module_names, :module_path

    def initialize(template, options = {})
      @template = template

      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
        meta_class.send(:attr_reader, key)
      end

      @filename     ||= @template
      @name         ||= gem_name_from_directory
      @module_path  ||= name
      @module_names ||= module_names_from_path(module_path)
    end

    def write
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, 'w+') { |f| f.write(render) }
    end

    protected

      def module_names_from_path(path)
        names = []
        path.split('-').each do |segment|
          names << segment.camelize
        end
        names
      end

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
