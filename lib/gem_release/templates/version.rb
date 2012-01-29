<%=
  i = 0
  opening = ""
  closing = ""
  module_names.each do |n|
    opening += "#{' ' * i}module #{n}\n"
    closing =  "#{' ' * i}end\n" + closing
    i += 2
  end

  opening + "#{' ' * i}VERSION = #{version.inspect}\n" + closing
%>