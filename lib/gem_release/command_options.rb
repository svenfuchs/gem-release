module GemRelease
  module CommandOptions
    def option(key, short, description)
      long    = "--[no-]#{key}"
      default = self.class::OPTIONS[key]
      add_option(short, long, description, "Defaults to #{default}") do |value, options| 
        options[key] = value
      end
    end
  end
end