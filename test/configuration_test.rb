require File.expand_path('../test_helper', __FILE__)

require 'gem_release/configuration'
# testing through release command
require 'rubygems/commands/bootstrap_command'
require 'rubygems/commands/release_command'

class ConfigurationTest < Test::Unit::TestCase

  PRIVATE_SERVER = "http://password:clever@private-gem.server.io"

  def setup
    Configuration.options = nil # clear previous test cache
    @custom_opts = { :host => PRIVATE_SERVER }
  end

  test "checks the cwd for gem-release files and uses the first one" do
    File.open("/tmp/.gem-release","w")
    orig_dir = Dir.pwd
    Dir.chdir "/tmp"
    assert Configuration.conf_path.match(".gem-release")
    Dir.chdir(orig_dir)
    FileUtils.rm("/tmp/.gem-release")
  end

  test "it holds configurations keys" do
    Configuration.options = @custom_opts
    assert_equal Configuration[:host], PRIVATE_SERVER
  end

  test "it holds configurations keys defined from a file" do
    File.open(".gem-release","w") do |f|
      f.puts YAML.dump(@custom_opts)
    end
    assert_equal Configuration[:host], PRIVATE_SERVER
    FileUtils.rm(".gem-release")
  end

  test "it will return nil if no configuration is defined" do
    assert_equal Configuration[:host], nil
  end

  test "it creates commands with configuration options it has registered" do
    Configuration.options = @custom_opts
    assert_equal Configuration[:host], PRIVATE_SERVER
    cmd = Gem::Commands::ReleaseCommand.new
    assert_equal cmd.options[:host], PRIVATE_SERVER
  end

end
