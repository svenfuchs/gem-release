require File.expand_path('../test_helper', __FILE__)

class VersionFileTest < Test::Unit::TestCase
  include GemRelease

  test "correct new version for pre version" do
    version_file = VersionFile.new(target: "pre")
    version_file.stubs(:old_number).returns("1.0.1.pre19")

    assert_equal "1.0.1.pre20", version_file.new_number
  end
end
