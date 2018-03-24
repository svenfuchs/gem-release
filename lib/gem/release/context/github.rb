require 'json'
require 'gem/release/helper/http'

module Gem
  module Release
    class Context
      class Github
        include Helper::Http

        URL = 'https://api.github.com/repos/%s/releases'

        MSGS = {
          error: 'GitHub returned %s (body: %p)'
        }

        attr_reader :repo, :data

        def initialize(repo, data)
          @repo = repo
          @data = data
        end

        def release
          resp = post(url, body, headers)
          status, body = resp
          raise Abort, MSGS[:error] % [status, body] unless status == 200
        end

        private

          def url
            URL % repo
          end

          def body
            JSON.dump(
              tag_name: data[:tag_name],
              name: data[:name],
              body: data[:descr],
              prerelease: pre?(data[:version])
            )
          end

          def headers
            {
              'User-Agent'    => "gem-release/v#{::Gem::Release::VERSION}",
              'Content-Type'  => 'text/json',
              'Authorization' => "token #{data[:token]}",
            }
          end

          def pre?(version)
            Version::Number.new(version).pre?
          end
      end
    end
  end
end
