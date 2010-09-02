module GemRelease
  class Gemspec < Template
    attr_reader :authors, :email, :homepage, :summary, :description

    def initialize(options = {})
      super

      @authors     ||= [`git config --get user.name`.strip]
      @email       ||= `git config --get user.email`.strip
      @homepage    ||= "http://github.com/#{github_user}/#{name}" || "[your github name]"

      @summary     ||= '[summary]'
      @description ||= '[description]'
      @strategy = options[:strategy]
    end
    
    def files
      case @strategy
      when 'git'
        '`git ls-files {app,lib}`.split("\n")'
      else
        'Dir.glob("lib/**/**")'
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
