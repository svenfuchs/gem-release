require 'yaml'

class Configuration
  class << self

    attr_accessor :options

    def options
      @options ||= if File.exist?(conf_path.to_s) && !File.directory?(conf_path.to_s)
                     YAML.load(File.read(conf_path)) || {}
                   else
                     {}
                   end
    end

    def conf_path
      File.expand_path(Dir.glob('**/.gem-release').first.to_s)
    end


    def []=(key,val)
      options[key] = val
    end

    def [](key)
      options[key]
    end

  end
end
