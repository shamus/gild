module Gild
  class Template
    def initialize(source)
      @builder = Class.new(Gild::TemplateBuilder)
      builder.template source.to_s
    end

    def render(scope, locals={})
      MultiJson.encode(builder.render(scope, locals).to_hash)
    end

    private
    attr_reader :builder
  end
end
