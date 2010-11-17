Dir[File.dirname(__FILE__) + '/**/test*.rb'].each do |filename|
  require filename
end
