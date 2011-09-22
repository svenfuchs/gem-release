module GemRelease
  VERSION = '0.0.21'

  class Version < Template
    attr_reader :version

    def initialize(options = {})
      super('version.rb', options)
      @version ||= '0.0.1'
    end

    def filename
      "lib/#{module_path}/version.rb"
    end
  end if defined?(Template)
end
