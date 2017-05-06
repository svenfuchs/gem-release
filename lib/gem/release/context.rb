require 'gem/release/context/gem'
require 'gem/release/context/paths'
require 'gem/release/context/system'

module Gem
  module Release
    class Context
      class << self
        attr_accessor :last
      end

      attr_accessor :config, :gem, :system

      COLORS = {
        red:    "\e[31m",
        green:  "\e[32m",
        yellow: "\e[33m",
        blue:   "\e[34m",
        gray:   "\e[37m",
        reset:  "\e[0m"
      }

      def initialize(name = nil)
        @config = Config.new
        @gem    = Gem.new(name || File.basename(Dir.pwd))
        @system = System.new
      end

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

      def abort(str)
        error(str)
        exit 1
      end

      def in_dirs(args, opts, &block)
        Paths::ByNames.new(args, opts).in_dirs(&block)
      end

      def in_gem_dirs(args, opts, &block)
        Paths::ByGemspecs.new(args, opts).in_dirs(&block)
      end

      private

        def colored(color, str)
          [COLORS[color], str, COLORS[:reset]].join
        end

        def with_spacing(str, space)
          str = "\n#{str}" if space && !self.class.last
          self.class.last = space
          str
        end
    end
  end
end
