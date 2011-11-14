require 'gild/builder'
require 'gild/render_context'
require 'gild/template'
require 'gild/template_builder'
require 'gild/version'

require 'extensions/string.rb'
require 'multi_json'

module Gild
  def self.register!
    require 'gild/initializers/railtie' if defined?(Rails) && Rails.version =~ /^3/
  end

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

Gild.register!
