module Gem
  module Release
    class Context
      class System
        def run(cmd)
          system(cmd)
        end

        def gem_cmd(cmd, *args)
          ::Gem::Commands.const_get("#{cmd.to_s.capitalize}Command").new.invoke(*args.flatten)
          # TODO what's with the return value? maybe add our own abstraction that can check the result?
          true
        end

        def git_remotes
          `git remote`.split("\n")
        end

        def git_user_name
          str = `git config --get user.name`.strip
          str unless str.empty?
        end

        def git_user_email
          str = `git config --get user.email`.strip
          str unless str.empty?
        end

        def github_user_name
          str = `git config --get github.user`.strip
          str.empty? ? git_user_name : str
        end
      end
    end
  end
end
