module GemRelease
  class License < Template
    attr_reader :author, :email, :year

    def initialize(options = {})
      super

      @author  ||= user_name
      @email   ||= user_email
      @year    ||= Time.now.year
    end

    def template_name
      'gemspec.erb'
    end
  end
end

