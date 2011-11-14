module Gild
  class TemplateBuilder < Builder
    def self.template(source)
      @template_source = source
    end

    def self.render(scope = Object.new, locals = {})
      scope.extend Gild::RenderContext
      helpers.each { |h| scope.extend h }
      render_with_template scope, locals
    end

    def self.render_with_template(template, locals = {})
      template.local_assigns = locals
      template.instance_eval locals.map { |k,v| "#{k.to_s} = local_assigns[:#{k}];" }.join
      template.instance_eval @template_source unless @template_source.to_s.empty?
      template
    end
  end
end
