module Gild
  class RenderContext
    class Stack
      def push(object, hash = {})
        stack.push [object, hash]
      end
  
      def pop
        stack.pop
      end
  
      def current_object
        stack.last[0]
      end
  
      def current_hash
        stack.last[1]
      end
  
      private
  
      def stack
        @stack ||= []
      end
    end

    attr_accessor :to_hash

    def initialize(scope, context = nil, to_hash = {})
      @scope = scope
      @to_hash = to_hash
      @stack = Stack.new.tap { |rc| rc.push context, @to_hash }

      copy_instance_variables!
    end

    def object(context, options = {}, &b)
      name = Gild.gilded_name(options[:as] || context)
      stack.current_hash[name] = constuct_object(context, {}, options, &b)
    end

    def attributes(names)
      Array(names).each { |a| attribute(a) }
    end

    def attribute(name)
      value = stack.current_object.send(name.to_sym)
      stack.current_hash[name.to_s] = block_given? ? yield(value) : value
    end

    def virtual(name)
      stack.current_hash[name.to_s] = yield(stack.current_object)
    end

    def array(array, options = {}, &b)
      name = Gild.gilded_name(options[:as] || array)
      stack.current_hash[name] = [].tap do |objects|
        array.each do |c|
          objects << constuct_object(c, {}, options, &b) 
        end
      end
    end

    def render(builder)
      builder.render_with_template(self)
    end

    private
    attr_reader :scope, :stack

    def constuct_object(context, hash, options, &b)
      stack.push context, hash
      attributes(options[:attributes])
      instance_eval { b.call(context) } if block_given?
      stack.pop[1]
    end

    def copy_instance_variables!
      scope.instance_variables.map(&:to_s).each do |name|
        instance_variable_set(name, scope.instance_variable_get(name))
      end
    end

    def respond_to?(name, include_private=false)
      @scope.respond_to?(name, include_private) ? true : super
    end

    def method_missing(name, *args, &block)
      @scope.respond_to?(name) ? @scope.send(name, *args, &block) : super
    end
  end
end
