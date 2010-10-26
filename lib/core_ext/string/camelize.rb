class String
  def camelize
    split(/[^a-z0-9]/i).map { |word| word.capitalize }.join
  end
end unless String.new.respond_to?(:camelize)