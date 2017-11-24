def parse_ini_section(section, params)
  content = "[#{section}]\n"
  params.each do |param_name, param_value|
    param_value = '1' if param_value.is_a?(TrueClass)
    param_value = '0' if param_value.is_a?(FalseClass)
    content << "#{param_name} = #{param_value.dump}\n"
  end
  content
end
