module GemRelease
  class GemspecTemplate < Template
    attr_reader :author, :email, :homepage, :summary, :description, :strategy

    def initialize(options = {})
      super('gemspec', options)

      @author      ||= user_name
      @email       ||= user_email
      @homepage    ||= "https://github.com/#{github_user}/#{name}" || "[your github name]"

      @summary     ||= 'TODO: summary'
      @description ||= 'TODO: description'

      @strategy = options[:strategy]
    end

    def files
      case strategy
      when 'git'
        '`git ls-files app lib`.split("\n")'
      else
        'Dir.glob("{lib/**/*,[A-Z]*}")'
      end
    end

    def exists?
      File.exists?(filename)
    end

    def filename
      "#{name}.gemspec"
    end
  end
end
