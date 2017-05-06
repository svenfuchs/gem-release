module Gem
  module Release
    class Context
      module Ui
        class Terminal
          COLORS = {
            red:    "\e[31m",
            green:  "\e[32m",
            yellow: "\e[33m",
            blue:   "\e[34m",
            gray:   "\e[37m",
            reset:  "\e[0m"
          }

          def announce(str)
            puts colored(:green, with_spacing(str, true))
          end

          def info(str)
            puts colored(:blue, with_spacing(str, true))
          end

          def notice(str)
            puts colored(:gray, with_spacing(str, false))
          end

          def warn(str)
            puts colored(:yellow, with_spacing(str, false))
          end

          def error(str)
            puts colored(:red, with_spacing(str, true))
          end

          def success(str)
            announce(str)
            puts
          end

          private

            def colored(color, str)
              [COLORS[color], str, COLORS[:reset]].join
            end

            def with_spacing(str, space)
              str = "\n#{str}" if space && !@last
              @last = space
              str
            end
        end
      end
    end
  end
end
