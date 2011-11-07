require 'lib/gild'

describe Gild::RenderContext do
  let(:render_context) { Gild::RenderContext.new }
  let(:object) { Object.new }
  let(:hash) { {} }

  before { render_context.push object, hash }

  it "pops the last values off of the stack" do
    render_context.pop.should == [object, hash]
  end

  it "returns the current object on the top of the stack" do
    render_context.current_object.should == object
  end

  it "returns the current hash on top of the stack" do
    render_context.current_hash.should == hash
  end
end
