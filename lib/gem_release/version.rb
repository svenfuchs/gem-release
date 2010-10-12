module GemRelease
  VERSION = '0.0.14'

  class Version < Template
    attr_reader :version

    def initialize(options = {})
      super
      @version ||= '0.0.1'
    end

    def filename
      "lib/#{module_path}/version.rb"
    end

    def template_name
      'version.erb'
    end
  end if defined?(Template)
end
