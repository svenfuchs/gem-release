require 'forwardable'

module Gem
  module Release
    module Helper
      extend Forwardable
      def_delegators :context, :gem, :system
      def_delegators :system, :git_remotes, :git_user_name, :git_user_email,
        :github_user_name

      def run(cmd)
        return true if send(cmd)
      end

      def cmd(cmd, *args)
        if cmd.is_a?(Symbol)
          info cmd, *args
          cmd = self.class::CMDS[cmd] % args
        end
        notice "$ #{cmd}"
        result = pretend? ? true : system.run(cmd)
        abort "The command `#{cmd}` was unsuccessful." unless result
      end

      def gem_cmd(cmd, *args)
        info cmd, *args if cmd.is_a?(Symbol)
        notice "$ gem #{cmd} #{args.join(' ')}"
        pretend? ? true : system.gem_cmd(cmd, *args)
      end

      %w(announce notice info warn error).each do |level|
        define_method(level) do |msg, *args|
          msg = self.class::MSGS[msg] % args if msg.is_a?(Symbol)
          context.send(level, msg) unless quiet?
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
