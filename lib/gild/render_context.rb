module Gild
  class RenderContext
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
end
