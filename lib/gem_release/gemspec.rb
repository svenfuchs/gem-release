module GemRelease
  class Gemspec < Template
    attr_reader :authors, :email, :homepage, :summary, :description

    def initialize(options = {})
      super

      @authors     ||= [`git config --get user.name`.strip]
      @email       ||= `git config --get user.email`.strip
      @github_user ||= `git config --get github.user`.strip
      @homepage    ||= "http://github.com/#{@github_user}/#{name}" || "[your github name]"

      @summary     ||= '[summary]'
      @description ||= '[description]'
    end
    
    def files
      case @strategy || :git
      when :glob
        "Dir['{lib/**/*,[A-Z]*}']"
      when :git
        '`git ls-files {app,lib}`.split("\n")'
      end
    end
    
    def filename
      "#{name}.gemspec"
    end

    def template_name
      'gemspec.erb'
    end
  end
end