require 'erb'
require_relative 'helper/string'

module Gem
  module Release
    class Data < Struct.new(:git, :gem, :opts)
      include Helper::String

      KEYS = %i[
        gem_name gem_path module_names author email homepage
        licenses summary description files bin_files
      ].freeze

      def data
        KEYS.map { |key| [key, send(key)] }.to_h
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

        def user_login
          git.user_login || '[your login]'
        end

        def author
          git.user_name || '[your name]'
        end

        def email
          git.user_email || '[your email]'
        end

        def homepage
          "https://github.com/#{user_login}/#{gem_name}"
        end

        def licenses
          Array(license).join(',').split(',').map(&:upcase)
        end

        def license
          opts[:license] if opts[:license]
        end

        def files
          strategy[:files]
        end

        def bin_files
          strategy[:bin_files] if opts.key?(:bin) ? opts[:bin] : File.directory?('./bin')
        end

        def strategy
          STRATEGIES[(opts[:strategy] || :glob).to_sym] || STRATEGIES[:glob]
        end

        def summary
          '[summary]'
        end

        def description
          '[description]'
        end
    end
  end
end
