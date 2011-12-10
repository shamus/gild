class Object
  unless method_defined?(:instance_values)
    def instance_values
      instance_variables.inject({}) do |values, name|
        values[name.to_s[1..-1]] = instance_variable_get(name)
        values
      end
    end
  end

  unless method_defined?(:attributes)
    alias :attributes :instance_values
  end
end
