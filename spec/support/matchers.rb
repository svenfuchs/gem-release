RSpec::Matchers.define :have_file do |path, content = nil|
  match do |_|
    return false unless File.file?(path)
    content.nil? || File.read(path).include?(content)
  end

  failure_message do
    msg = "Expected the file #{path} to exist in #{Dir.pwd}"
    msg += " and include: #{content.inspect}" if content
    msg += ", but it does not exist." unless File.file?(path)
    msg += ". Instead the content is: #{File.read(path)}" if File.file?(path)
    msg
  end
end

RSpec::Matchers.define :have_version do |path, version|
  match do |_|
    return false unless File.file?(version(path))
    File.read(version(path)).include?("VERSION = '#{version}'")
  end

  failure_message do
    msg = "Expected the file #{version(path)} to define the version #{version}, but it does not. "
    if File.exist?("#{version(path)}")
      msg += "Instead it is:\n\n#{File.read("#{version(path)}")}"
    else
      msg += "The file does not exist."
    end
    msg
  end

  def version(path)
    path = "lib/#{path}"        unless path.include?('lib')
    path = "#{path}/version.rb" unless path.include?('version.rb')
    path
  end
end

RSpec::Matchers.define :output do |str|
  match do |e|
    out.any? { |line| line.include?(str) }
  end

  failure_message do
    <<-msg.split("\n").map(&:lstrip).join("\n")
      Expected stdout to include the string #{str.inspect}, but it does not.\n
      stdout is:\n
      #{out.join("\n")}
    msg
  end

  failure_message_when_negated do
    <<-msg.split("\n").map(&:lstrip).join("\n")
      Expected stdout to not include the string #{str.inspect}, but it does.\n
      stdout is:\n
      #{out.join("\n")}
    msg
  end
end

RSpec::Matchers.define :run_cmd do |cmd|
  match do |e|
    cmds.include?(cmd)
  end

  failure_message do
    <<-msg.split("\n").map(&:lstrip).join("\n")
      Expected the command `#{cmd}` to have run, but it did not.\n
      Run commands are:\n
      #{cmds.join("\n")}
    msg
  end
end

RSpec::Matchers.define :specify do |name, value|
  match do |gemspec|
    line = gemspec.split("\n").detect { |line| line =~ /#{name}\s+=/ }
    line && line.include?(value)
  end

  failure_message do |gemspec|
    <<-msg.split("\n").map(&:lstrip).join("\n")
      Expected this gemspec to specify #{name} as #{value.inspect}, but it did not.\n
      The gemspec is:\n
      #{gemspec}
    msg
  end
end
