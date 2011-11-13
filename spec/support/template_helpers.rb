module Gild::TemplateHelpers
  def execute_template_in_scope(scope, &b)
    scope.instance_eval &b
  end
end
