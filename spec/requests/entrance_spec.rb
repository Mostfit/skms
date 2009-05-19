require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/entrance" do
  before(:each) do
    @response = request("/entrance")
  end
end