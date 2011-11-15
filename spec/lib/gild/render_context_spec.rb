require 'spec_helper'
require 'lib/gild'

module Gild
  module Test
    class TestObject
      def foo; :foo; end
      def bar; :bar; end
      def things; [:foo, :bar]; end
    end

    class IncludedBuilder < Gild::Builder
      template { @evaluated_in = self }
    end
  end
end

describe Gild::RenderContext do
  let(:scope) { Object.new }
  let(:scope_with_initial_context) do
    scope.tap do |s|
      def s.initial_context
        Gild::Test::TestObject.new
      end
    end
  end

  before { scope.extend described_class }

  describe "configuring" do
    it "defaults the initial hash and context" do
      scope.to_hash.should == {}
    end

    it "accepts a custom value for the initial hash" do
      def scope.initial_hash
        { :supplied => true }
      end
      scope.to_hash.should == { :supplied => true }
    end

    it "accepts a custom value for the initial object" do
      execute_template_in_scope(scope_with_initial_context) { attributes [:foo, :bar] }
      scope.to_hash.should == { 'foo' => :foo, 'bar' => :bar }
    end
  end

  describe "rendering an object" do
    it "accepts a symbol as the name of the object" do
      execute_template_in_scope(scope) { object :symbol }
      scope.to_hash.should have_key('symbol')
    end

    it "derives the object name from the object type" do
      execute_template_in_scope(scope) { object Gild::Test::TestObject.new }
      scope.to_hash.should have_key('test_object')
    end

    it "uses the name provided by the :as option" do 
      execute_template_in_scope(scope) { object Gild::Test::TestObject.new, :as => :foo }
      scope.to_hash.should have_key('foo')
    end

    it "delegates to attributes if the :attributes option is specified" do
      scope.should_receive(:attributes).with([:foo, :bar])
      execute_template_in_scope(scope) { object Gild::Test::TestObject.new, :attributes => [:foo, :bar] }
    end

    it "executes the provided block in the context of the template" do
      execute_template_in_scope(scope) { object(:foo) { @executed_in = self } }
      scope.instance_variable_get(:"@executed_in").should == scope
    end

    it "yields the supplied object to the block" do
      execute_template_in_scope(scope) { object(:thing) { |o| @yielded = o } }
      scope.instance_variable_get(:"@yielded").should == :thing
    end
  end

  describe "rendering a set of attributes" do
    it "delegates to attribute to render each speficied attribute" do
      scope.should_receive(:attribute).with(:foo)
      scope.should_receive(:attribute).with(:bar)
      execute_template_in_scope(scope_with_initial_context) { attributes [:foo, :bar] }
    end
  end

  describe "rendering a single atribute" do
    it "uses the attribute value from the object" do
      execute_template_in_scope(scope_with_initial_context) { attribute(:foo) }
      scope.to_hash['foo'].should == :foo
    end

    it "yields the attribute value and uses the return value of the supplied block" do
      execute_template_in_scope(scope_with_initial_context) { attribute(:foo) { |value| "#{value} was yielded" } }
      scope.to_hash['foo'].should == "foo was yielded"
    end
  end

  describe "rendering a virtual attribute" do
    it "yields the current context and uses the return value of the supplied block" do
      execute_template_in_scope(scope_with_initial_context) { virtual(:thing) { |o| "#{o.foo} and #{o.bar}" } }
      scope.to_hash['thing'].should == "foo and bar"
    end
  end

  describe "rendering an array of objects" do
    context "when a symbol is provided" do
      before do
        test_object = Gild::Test::TestObject.new
        test_object.should_receive(:things).once.and_return([])
        execute_template_in_scope(scope) do
          object(test_object) { array(:things) {} }
        end
      end

      it "uses it as the name" do
        scope.to_hash['test_object'].should have_key('things')
      end
    end

    context "when an array is provided" do
      it "derives the object name from the first object's type" do
        execute_template_in_scope(scope) { array([Gild::Test::TestObject.new]) { } }
        scope.to_hash.should have_key('test_objects')
      end
    end

    it "uses the name provided by the :as option" do
       execute_template_in_scope(scope) { array([Gild::Test::TestObject.new], :as => 'objects') { } }
       scope.to_hash.should have_key('objects')
    end

    it "delegates to attributes once for each object in the array if :attribtues is specified" do
      scope.should_receive(:attributes).with(:foo).twice
      execute_template_in_scope(scope) do
        array([Gild::Test::TestObject.new, Gild::Test::TestObject.new], :attributes => :foo) { }
      end
    end

    it "yields the given block once for each object in the array" do
      execute_template_in_scope(scope) do
        array [Gild::Test::TestObject.new, Gild::Test::TestObject.new], :attributes => :foo do
          @call_count = @call_count.to_i + 1
        end
      end
      scope.instance_variable_get("@call_count").should == 2
    end
  end

  describe "including another builder" do
    it "executes the builder's template block in the context of this template" do
      execute_template_in_scope(scope) { include(Gild::Test::IncludedBuilder) }
      scope.instance_variable_get(:"@evaluated_in").should == scope
    end
  end
end
