require 'yaml'
require 'core_ext/hash/symbolize_keys'

class Configuration

  attr_reader :options

  def initialize
    load_options!
  end

  def load_options!
    @options = Hash.new { |hash, key| hash[key] = {} }
    if File.exist?(conf_path.to_s) && !File.directory?(conf_path.to_s)
      config_hash = YAML.load(File.read(conf_path))
      if config_hash
        @options.merge!(config_hash.deep_symbolize_keys!)
      end
    end
  end

  def conf_path
    File.expand_path(Dir.glob('**/.gemrelease').first.to_s)
  end

  def []=(key,val)
    options[key] = val
  end

  def [](key)
    options[key]
  end
end
