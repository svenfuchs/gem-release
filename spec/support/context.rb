require 'forwardable'

module Support
  module Context
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.let(:context) { Context.new }
      base.let(:git)     { context.git }
      base.let(:cmds)    { context.cmds }
      base.let(:out)     { context.out }
    end

    module ClassMethods
      def remotes(*args)
        before { git.remotes = ['foo'] }
      end
    end

    class Git
      attr_accessor :clean, :remotes, :tags, :user_name,
        :user_email, :user_login

      def initialize
        @clean = true
        @remotes = ['origin']
        @tags = []
        @user_name = 'Sven Fuchs'
        @user_email = 'me@svenfuchs.com'
        @user_login = 'svenfuchs'
      end

      def clean?
        !!@clean
      end
    end

    class Ui
      attr_reader :out

      def initialize
        @out = []
      end

      %w(announce notice info warn error success).each do |level|
        define_method(level) do |msg|
          out << msg
        end
      end
    end

    class Context < Gem::Release::Context
      extend Forwardable

      attr_accessor :cmds
      def_delegators :ui, :out

      def initialize(*args)
        super
        @cmds = []
        @git = Git.new
        @ui = Ui.new
      end

      def run(cmd)
        cmds << cmd
      end

      def gem_cmd(*args)
        cmds << "gem #{args.join(' ')}"
      end

      def abort(str)
        ui.error(str)
        fail str
      end
    end
  end
end
