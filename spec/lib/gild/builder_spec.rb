require 'spec_helper'
require 'lib/gild'

module Gild
  module Test
    module Helper
      def im_helping!; end
    end

    class TestBuilder < Gild::Builder
      helper Gild::Test::Helper
      template do 
        @block_evaluated_in = self
      end
    end
  end
end

describe Gild::Builder do
  before { @template = Gild::Test::TestBuilder.render Object.new }

  it "extends the template class with the supplied helpers" do
    @template.should respond_to(:im_helping!)
  end

  it "executes the template block in the context of the template class" do
    @template.instance_variable_get(:"@block_evaluated_in").should == @template
  end
end
