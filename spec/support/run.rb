module Support
  module Run
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.subject {}
    end

    module ClassMethods
      def run_cmd(*args)
        before { run(*args) }
      end
    end

    def run(cmd = nil, args = nil, opts = nil)
      cmd  ||= respond_to?(:cmd) ? cmd : described_class.registry_key
      args ||= self.args
      opts ||= self.opts
      Gem::Release::Cmds::Runner.new(context, cmd, args, opts).run
    end
  end
end
