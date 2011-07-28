source :rubygems
gemspec

group :development, :test do
  platforms :mri_18 do
    # required as linecache uses it but does not have it as a dep
    gem "require_relative", "~> 1.0.1"
    gem 'ruby-debug'
  end

  platforms :mri_19 do
    # sadly ruby-debug19 (linecache19) doesn't
    # work with ruby-head, but we don't use this in
    # development so this should cover us just in case
    unless RUBY_VERSION == '1.9.3'
      gem 'ruby-debug19', :platforms => :mri_19
    end
  end
end
