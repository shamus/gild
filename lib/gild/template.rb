module Gild
  class Template
    def initialize(source)
      @builder = Class.new(Gild::Builder)
      builder.template source
    end

    def render(scope, locals={}, &b)
      #TODO: locals
      #TODO: what is this block??
      MultiJson.encode(builder.render(scope, &b).to_hash)
    end

    private
    attr_accessor :builder
  end
end
