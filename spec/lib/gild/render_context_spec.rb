require 'spec_helper'
require 'lib/gild'

module Gild
  module Test
    class TestObject
      def foo; :foo; end
      def bar; :bar; end
    end

    class IncludedBuilder < Gild::Builder
      template { @evaluated_in = self }
    end
  end
end

describe Gild::RenderContext do
  let(:included_builder) { Gild::Test::IncludedBuilder }
  let(:test_object) { Gild::Test::TestObject.new }
  let(:template) { described_class.new(test_object) }

  describe "creation" do
    it "defaults the json hash with an empty hash" do
      described_class.new.to_hash.should == {}
    end

    it "accepts a custom value for the json hash" do
      supplied_hash = { "supplied" => true }
      described_class.new(Object.new, {}, supplied_hash).to_hash.should == supplied_hash
    end

    it "sets the specified instance variables" do
      scope = { "@foo" => :foo, "@bar" => :bar }
      template = described_class.new(Object.new, scope)
      template.instance_variable_get("@foo").should == :foo
      template.instance_variable_get("@bar").should == :bar
    end
  end

  describe "rendering a new object" do
    it "accepts a symbol as the name of the object" do
      template.object :symbol
      template.to_hash.should have_key('symbol')
    end

    it "derives the object name from the object type" do
      template.object test_object
      template.to_hash.should have_key('test_object')
    end

    it "uses the name provided by the :as option" do
      template.object test_object, :as => :foo
      template.to_hash.should have_key('foo')
    end

    it "delegates to attributes if the :attributes option is specified" do
      template.should_receive(:attributes).with([:foo, :bar])
      template.object test_object, :attributes => [:foo, :bar]
    end

    it "executes the provided block in the context of the template" do
      template.instance_eval do
        object(:test_object) { @executed_in = self }
      end
      template.instance_variable_get(:"@executed_in").should == template
    end
  end

  describe "rendering a set of attributes" do
    it "delegates to attribute to render each speficied attribute" do
      template.should_receive(:attribute).with(:foo)
      template.should_receive(:attribute).with(:bar)
      template.attributes [:foo, :bar]
    end
  end
  
  describe "rendering a single atribute" do
    it "uses the attribute value from the object" do
      template.attribute(:foo)
      template.to_hash['foo'].should == :foo
    end

    it "yields the attribute value from the object and uses the return value" do
      template.attribute(:foo) { |value| "#{value} was yielded" }
      template.to_hash['foo'].should == "foo was yielded"
    end
  end

  describe "rendering a virtual attribute" do
    it "yields the current object and assigns the result to the specified attribute name" do
      template.virtual(:thing) { |object| "#{object.foo} and #{object.bar}" }
      template.to_hash['thing'].should == "foo and bar"
    end
  end
  
  describe "rendering an array of objects" do
    it "derives the object name from the first object's type" do
      template.array([test_object]) { }
      template.to_hash.should have_key('test_objects')
    end

    it "uses the name provided by the :as option" do
      template.array([test_object], :as => 'objects') { }
      template.to_hash.should have_key('objects')
    end

    it "delegates to attributes once for each object in the array if :attribtues is specified" do
      template.should_receive(:attributes).with(:foo).twice
      template.array([test_object, test_object], :attributes => :foo) { }
    end

    it "yields the given block once for each object in the array" do
      template.instance_eval do
        array [Gild::Test::TestObject.new, Gild::Test::TestObject.new], :attributes => :foo do
          @call_count = @call_count.to_i + 1
        end
      end
      template.instance_variable_get("@call_count").should == 2
    end
  end

  describe "including another builder" do
    it "executes the builder's template block in the context of this template" do
      template.render(included_builder)
      template.instance_variable_get(:"@evaluated_in").should == template
    end
  end
end
