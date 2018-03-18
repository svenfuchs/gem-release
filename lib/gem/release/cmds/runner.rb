require 'gem/release/context'

module Gem
  module Release
    module Cmds
      class Runner < Struct.new(:context, :name, :args, :opts)
        def run
          run_cmd
          success
        end

        private

          def run_cmd
            const.new(context, args, opts).run
          end

          def const
            Base[name]
          end

          def opts
            except(super, :args, :build_args)
          end

          def args
            super.select { |arg| arg.is_a?(String) && arg[0] != '-' }
          end

          def success
            return if quiet? || !$stdout.tty?
            context.ui.success "All is good, thanks my friend."
          end

          def quiet?
            opts[:quiet] || opts[:silent]
          end

          def opts
            @opts ||= config.merge(super)
          end

          def config
            context.config.for(name.to_sym)
          end

          def except(hash, *keys)
            hash.reject { |key, _| keys.include?(key) }
          end
      end
    end
  end
end
