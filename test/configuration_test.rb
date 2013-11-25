require File.expand_path('../test_helper', __FILE__)

require 'gem_release/configuration'
# testing through release command
require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/release_command'

class ConfigurationTest < Test::Unit::TestCase

  PRIVATE_SERVER = "http://password:clever@private-gem.server.io"

  def make_config_file(string_keys = false)
    File.open(".gemrelease","w") do |f|
      if string_keys
        f.puts YAML.dump('release' => {'host' => PRIVATE_SERVER})
      else
        f.puts YAML.dump(:release => {:host => PRIVATE_SERVER})
      end
    end
  end

  def destroy_config_file
    FileUtils.rm(".gemrelease")
  end

  test "checks the cwd for gemrelease files and uses the first one" do
    @configuration = Configuration.new
    File.open("/tmp/.gemrelease","w")
    orig_dir = Dir.pwd
    Dir.chdir "/tmp"
    assert @configuration.conf_path.match(".gemrelease")
    Dir.chdir(orig_dir)
    FileUtils.rm("/tmp/.gemrelease")
  end

  test "it holds configurations keys" do
    @configuration = Configuration.new
    @configuration[:release][:host] = PRIVATE_SERVER
    assert_equal @configuration[:release][:host], PRIVATE_SERVER
  end

  test "it holds configurations keys defined from a file" do
    make_config_file
    @configuration = Configuration.new
    assert_equal @configuration[:release][:host], PRIVATE_SERVER
    destroy_config_file
  end

  test "it holds configurations keys defined from a file for string keys as well" do
    make_config_file(true)
    @configuration = Configuration.new
    assert_equal @configuration[:release][:host], PRIVATE_SERVER
    destroy_config_file
  end

  test "it will return nil if no configuration is defined" do
    @configuration = Configuration.new
    assert_equal @configuration[:release][:host], nil
  end

  test "it creates commands with configuration options it has registered" do
    make_config_file
    @configuration = Configuration.new
    assert_equal @configuration[:release][:host], PRIVATE_SERVER
    cmd = Gem::Commands::ReleaseCommand.new
    assert_equal cmd.options[:host], PRIVATE_SERVER
    destroy_config_file
  end

end
