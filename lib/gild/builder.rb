module Gild
  class Builder
    def self.helper(helper)
      helpers << helper
    end

    def self.template(source = nil, &b)
      @template_source = source
      @template_block = b
    end

    def self.render(scope = Object.new, &b)
      helpers.each { |h| scope.extend h }
      template = Gild::RenderContext.new scope, initial_context, initial_hash
      render_with_template template, &b
    end

    def self.render_with_template(template, &b)
      template.instance_eval @template_source unless @template_source.to_s.empty?
      template.instance_eval &@template_block if @template_block
      template.instance_eval &b if block_given?
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
