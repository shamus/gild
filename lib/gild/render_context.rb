module Gild
  module RenderContext
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

    def to_hash
      stack.current_hash
    end

    private

    def stack
      @_stack ||= Stack.new.tap do |s| 
        ih = respond_to?(:initial_hash) ? initial_hash : {}
        ic = respond_to?(:initial_context) ? initial_context : nil 
        s.push(ic, ih)
      end
    end

    def constuct_object(context, hash, options, &b)
      stack.push context, hash
      attributes(options[:attributes])
      instance_eval { b.call(context) } if block_given?
      stack.pop[1]
    end
  end
end
