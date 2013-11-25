class Hash

  #taken from https://gist.github.com/tommeier/1479299
  def deep_symbolize_keys!
    self.keys.each do |k|
      new_key = k.to_sym
      current_value = self.delete(k)
      self[new_key] = current_value.is_a?(Hash) ? current_value.dup.deep_symbolize_keys! : current_value
    end
    self
  end

end
