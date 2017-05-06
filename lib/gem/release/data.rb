require 'erb'
require 'ostruct'
require 'gem/release/helper/string'

module Gem
  module Release
    class Data < Struct.new(:system, :gem, :opts)
      include Helper::String

      def data
        {
          gem_name:     gem_name,
          gem_path:     gem_path,
          module_names: module_names,
          author:       user_name,
          email:        user_email,
          homepage:     homepage,
          licenses:     licenses,
          summary:      '[summary]',
          description:  '[description]',
          files:        files
        }
      end

      private

        def module_names
          gem_name.split('-').map { |part| camelize(part) }
        end

        def gem_name
          gem.name || raise('No gem_name given.')
        end

        def gem_path
          gem_name.gsub('-', '/').sub(/_rb$/, '')
        end

        def user_name
          system.git_user_name || '[your name]'
        end

        def user_email
          system.git_user_email || '[your email]'
        end

        def homepage
          "https://github.com/#{user_name}/#{gem_name}"
        end

        def licenses
          Array(license).join(',').split(',').map(&:upcase)
        end

        def license
          opts[:license] if opts[:license]
        end

        def files
          STRATEGIES[(opts[:strategy] || :glob).to_sym] || STRATEGIES[:glob]
        end
    end
  end
end
