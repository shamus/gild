require 'lib/gild'

describe Gild::Template do
  let(:template) { Gild::Template.new("object :test") }
  before { @json = template.render(Object.new) }

  it "executes the template block in the context of the template class" do
    @json.should == '{"test":{}}'
  end
end
