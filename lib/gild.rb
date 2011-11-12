require 'gild/version'
require 'gild/builder'
require 'gild/render_context'

module Gild
  def self.gilded_name(object)
    if object.is_a?(Symbol) or object.is_a?(String)
      object.to_s
    else
      thing_that_responds_to_name = object.is_a?(Array) ? object.first.class : object.class
      name = thing_that_responds_to_name.name.split('::').last.underscore.downcase
      name += "s" if object.is_a?(Array)
      name
    end
  end
end

unless String.method_defined?(:underscore)
  class String
    def underscore
      word = self.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
