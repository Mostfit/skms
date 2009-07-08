require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/tags" do
  before(:each) do
    @response = request("/tags")
  end
end