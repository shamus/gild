require 'gild/version'
require 'gild/builder'
require 'gild/render_context'

require 'extensions/string.rb'

module Gild
  def self.gilded_name(object)
    if object.is_a?(Symbol) or object.is_a?(String)
      object.to_s
    else
      thing_that_responds_to_name = object.is_a?(Array) ? object.first.class : object.class
      name = thing_that_responds_to_name.name.demodulize.underscore.downcase
      name = name.pluralize if object.is_a?(Array)
      name
    end
  end
end
