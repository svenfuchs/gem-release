require 'yaml'
require_relative '../helper/hash'

module Gem
  module Release
    class Config
      class Files
        include Helper::Hash

        FILES = %w[.gem_release/config.yml .gem_release.yml]

        def load
          return {} unless path
          symbolize_keys(YAML.load_file(path) || {})
        end

        def combine_paths
          folders = ['./', xdg_config_home, '~/']

          folders.product(FILES).map do |folder, file|
            File.join(folder, file)
          end
        end

        private

          def path
            @path ||= paths.first
          end

          def paths
            paths = combine_paths.map { |path| File.expand_path(path) }
            paths.select { |path| File.exist?(path) }
          end

          def xdg_config_home
            home_config =  File.join(ENV.fetch('HOME'), '.config')
            ENV.fetch('XDG_CONFIG_HOME', home_config)
          end
      end
    end
  end
end
