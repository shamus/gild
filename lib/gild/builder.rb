module Gild
  class Builder
    def self.helper(helper)
      helpers << helper
    end

    def self.template(&b)
      @template_block = b
    end

    def self.render(scope = Object.new)
      scope.extend Gild::RenderContext
      helpers.each { |h| scope.extend h }
      render_with_template scope
    end

    def self.render_with_template(template)
      template.instance_eval &@template_block if @template_block
      template
    end

    private
    def self.helpers
      @helpers ||= []
    end
  end
end
