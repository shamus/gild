module Gild
  class Builder
    def self.helper(helper)
      helpers << helper
    end

    def self.template(&b)
      @template = b
    end

    def self.render(scope = {})
      template = Gild::RenderContext.new initial_context, scope, initial_hash
      helpers.each { |h| template.extend h }
      render_with_template template
    end

    def self.render_with_template(template)
      template.instance_eval &@template
      template
    end

    def self.initial_context
      nil
    end

    def self.initial_hash
      {}
    end

    private
    def self.helpers
      @helpers ||= []
    end
  end
end
