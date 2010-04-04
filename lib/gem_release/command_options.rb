module GemRelease
  module CommandOptions
    def initialize(*args)
      @arguments = ''
      super
    end

    def option(key, short, description)
      options = self.class::OPTIONS
      default = options[key]

      if String === default
        long = "--#{key} #{key.to_s.upcase}"
        args = [short, long, String, "description (defaults to #{default})"]
      else
        long = "--[no-]#{key}"
        args = [short, long, "description (defaults to #{default})"]
      end

      add_option(*args) { |value, options| options[key] = value }
    end
  end
end