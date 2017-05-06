require 'forwardable'

module Gem
  module Release
    module Helper
      extend Forwardable
      def_delegators :context, :gem, :git, :ui

      def run(cmd)
        return true if send(cmd)
      end

      def cmd(cmd, *args)
        if cmd.is_a?(Symbol)
          info cmd, *args
          cmd = self.class::CMDS[cmd] % args
        end
        cmd = cmd.strip
        notice "$ #{cmd}"
        result = pretend? ? true : context.run(cmd)
        abort "The command `#{cmd}` was unsuccessful." unless result
      end

      def gem_cmd(cmd, *args)
        info cmd, *args if cmd.is_a?(Symbol)
        notice "$ gem #{cmd} #{args.join(' ')}"
        pretend? ? true : context.gem_cmd(cmd, *args)
      end

      %w(announce notice info warn error).each do |level|
        define_method(level) do |msg, *args|
          msg = self.class::MSGS[msg] % args if msg.is_a?(Symbol)
          ui.send(level, msg.strip) unless quiet?
        end
      end

      def abort(msg, *args)
        msg = self.class::MSGS[msg] % args if msg.is_a?(Symbol)
        msg = "#{msg} Aborting."
        context.abort(msg)
      end
    end
  end
end
