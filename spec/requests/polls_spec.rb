require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a poll exists" do
  Poll.all.destroy!
  request(resource(:polls), :method => "POST", 
    :params => { :poll => { :id => nil }})
end

describe "resource(:polls)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:polls))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of polls" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a poll exists" do
    before(:each) do
      @response = request(resource(:polls))
    end
    
    it "has a list of polls" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Poll.all.destroy!
      @response = request(resource(:polls), :method => "POST", 
        :params => { :poll => { :id => nil }})
    end
    
    it "redirects to resource(:polls)" do
      @response.should redirect_to(resource(Poll.first), :message => {:notice => "poll was successfully created"})
    end
    
  end
end

describe "resource(@poll)" do 
  describe "a successful DELETE", :given => "a poll exists" do
     before(:each) do
       @response = request(resource(Poll.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:polls))
     end

   end
end

describe "resource(:polls, :new)" do
  before(:each) do
    @response = request(resource(:polls, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@poll, :edit)", :given => "a poll exists" do
  before(:each) do
    @response = request(resource(Poll.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@poll)", :given => "a poll exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Poll.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @poll = Poll.first
      @response = request(resource(@poll), :method => "PUT", 
        :params => { :poll => {:id => @poll.id} })
    end
  
    it "redirect to the poll show action" do
      @response.should redirect_to(resource(@poll))
    end
  end
  
end

