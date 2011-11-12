class String
  unless method_defined?(:underscore)
    def underscore
      word = self.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end

  unless method_defined?(:pluralize)
    def pluralize
      self.dup + "s"
    end
  end

  unless method_defined?(:demodulize)
    def demodulize
      self.dup.gsub(/^.*::/, '')
    end
  end
end
