require 'spec_helper'
require 'lib/gild'

describe Gild::Template do
  let(:template) { Gild::Template.new("object :test") }
  before { @json = template.render(Object.new) }

  it "executes the template and returns some json" do
    MultiJson.decode(@json).should == { "test" => {} }
  end
end
