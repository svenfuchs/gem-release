module GemRelease
  module CommandOptions
    def initialize(*args)
      @arguments = ''
      super
    end

    def default_options_with(passed_opts)
      self.class::DEFAULTS.merge(Configuration.new[name.to_sym]).merge(passed_opts)
    end

    def option(key, short, description)
      default = Configuration.new[name.to_sym][key] || self.class::DEFAULTS[key]

      if default.is_a?(String)
        long = "--#{key} #{key.to_s.upcase}"
        if default == ''
          default_description = 'not set by default'
        else
          default_description = "defaults to #{default}"
        end
        args = [short, long, String, "#{description} (#{default_description})"]
      else
        long = "--[no-]#{key}"
        args = [short, long, "#{description} (defaults to #{default})"]
      end

      add_option(*args) { |value, options| options[key] = value }
    end
  end
end
