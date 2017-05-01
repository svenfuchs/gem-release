module Support
  module Context
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.let(:context)  { Context.new }
      base.let(:system)   { context.system }
      base.let(:cmds)     { Context.cmds }
      base.let(:gem_cmds) { Context.gem_cmds }
      base.let(:out)      { Context.out }
      base.before { Context.reset }
    end

    module ClassMethods
      def remotes(*args)
        before { allow(system).to receive(:git_remotes).and_return(['foo']) }
      end
    end

    class System
      class << self
        attr_accessor :git_remotes
      end

      def git_clean?
        true
      end

      def git_remotes(remotes = nil)
        remotes ? self.class.git_remotes = remotes : self.class.git_remotes || ['origin']
      end

      def git_user_name
      end

      def git_user_email
      end

      def github_user_name
        'svenfuchs'
      end

      def run(cmd)
        Context.cmds << cmd
      end

      def gem_cmd(*args)
        Context.cmds << "gem #{args.join(' ')}"
      end
    end

    class Context < Gem::Release::Context
      class << self
        def gem_cmds
          @gem_cmds ||= []
        end

        def cmds
          @cmds ||= []
        end

        def out
          @out ||= []
        end

        def reset
          @gem_cmds = []
          @cmds = []
          @out = []
        end
      end

      def initialize(*args)
        super
        @system = System.new
      end

      %w(announce notice info warn error).each do |level|
        define_method(level) do |msg|
          Context.out << msg
        end
      end

      def abort(str)
        error(str)
        fail str
      end
    end
  end
end
