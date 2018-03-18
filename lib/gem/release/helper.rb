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
        notice "$ #{cmd}" if tty?
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
          ui.send(level, format_msg(msg, args)) unless quiet?
        end
      end

      def format_msg(msg, args)
        send(:"format_msg_#{tty? ? :tty : :pipe}", msg, args)
      end

      def format_msg_tty(msg, args)
        msg = self.class::MSGS[msg] % args if msg.is_a?(Symbol)
        msg.strip
      end

      def format_msg_pipe(msg, args)
        msg = [msg, args].flatten.map(&:to_s)
        msg = msg.map { |str| quote_spaced(str) }
        msg.join(' ').strip
      end

      def quote_spaced(str)
        str.include?(' ') ? %("#{str}") : str
      end

      def tty?
        $stdout.tty?
      end

      def abort(msg, *args)
        msg = self.class::MSGS[msg] % args if msg.is_a?(Symbol)
        msg = "#{msg} Aborting."
        context.abort(msg)
      end
    end
  end
end
