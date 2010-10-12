require 'erb'
require 'fileutils'
require 'core_ext/string/camelize'

module GemRelease
  class Template
    include GemRelease::Helpers

    attr_reader :name, :module_name, :module_path, :options

    def initialize(options = {})
      @options = options
      options.each { |key, value| instance_variable_set(:"@#{key}", value) }

      @name        ||= gem_name_from_directory
      @module_path ||= name.gsub('-', '_')
      @module_name ||= module_path.camelize
    end

    def write
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, 'w+') { |f| f.write(render) }
    end

    def render
      ERB.new(template, nil, "%").result(binding)
    end

    def template
      File.new(File.expand_path("../templates/#{template_name}", __FILE__)).read
    end
  end
end
