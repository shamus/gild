module Gild
  class Template
    attr_accessor :to_hash

    def initialize(context = nil, scope = {}, to_hash = {})
      @to_hash = to_hash
      @render_context = Gild::RenderContext.new.tap { |rc| rc.push context, @to_hash }

      scope.each { |k,v| instance_variable_set(k, v) }
    end

    def object(context, options = {}, &b)
      name = Gild.gilded_name(options[:as] || context)
      render_context.current_hash[name] = constuct_object(context, {}, options, &b)
    end

    def attributes(names)
      Array(names).each { |a| attribute(a) }
    end

    def attribute(name)
      value = render_context.current_object.send(name.to_sym)
      render_context.current_hash[name.to_s] = block_given? ? yield(value) : value
    end

    def virtual(name)
      render_context.current_hash[name.to_s] = yield(render_context.current_object)
    end

    def array(array, options = {}, &b)
      name = Gild.gilded_name(options[:as] || array)
      render_context.current_hash[name] = [].tap do |objects|
        array.each { |c| objects << constuct_object(c, {}, options, &b) }
      end
    end

    def render(builder)
      builder.render_with_template(self)
    end

    private
    attr_reader :render_context

    def constuct_object(context, hash, options, &b)
      render_context.push context, hash
      attributes(options[:attributes])
      instance_eval &b if block_given?
      render_context.pop[1]
    end
  end
end