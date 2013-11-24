require 'yaml'

class Configuration

  attr_reader :options

  def initialize
    load_options!
  end

  def load_options!
    @options = Hash.new { |hash, key| hash[key] = {} }
    if File.exist?(conf_path.to_s) && !File.directory?(conf_path.to_s)
      @options.merge!(YAML.load(File.read(conf_path))) 
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
