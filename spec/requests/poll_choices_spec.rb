require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a poll_choice exists" do
  PollChoice.all.destroy!
  request(resource(:poll_choices), :method => "POST", 
    :params => { :poll_choice => { :id => nil }})
end

describe "resource(:poll_choices)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:poll_choices))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of poll_choices" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a poll_choice exists" do
    before(:each) do
      @response = request(resource(:poll_choices))
    end
    
    it "has a list of poll_choices" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      PollChoice.all.destroy!
      @response = request(resource(:poll_choices), :method => "POST", 
        :params => { :poll_choice => { :id => nil }})
    end
    
    it "redirects to resource(:poll_choices)" do
      @response.should redirect_to(resource(PollChoice.first), :message => {:notice => "poll_choice was successfully created"})
    end
    
  end
end

describe "resource(@poll_choice)" do 
  describe "a successful DELETE", :given => "a poll_choice exists" do
     before(:each) do
       @response = request(resource(PollChoice.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:poll_choices))
     end

   end
end

describe "resource(:poll_choices, :new)" do
  before(:each) do
    @response = request(resource(:poll_choices, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@poll_choice, :edit)", :given => "a poll_choice exists" do
  before(:each) do
    @response = request(resource(PollChoice.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@poll_choice)", :given => "a poll_choice exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(PollChoice.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @poll_choice = PollChoice.first
      @response = request(resource(@poll_choice), :method => "PUT", 
        :params => { :poll_choice => {:id => @poll_choice.id} })
    end
  
    it "redirect to the poll_choice show action" do
      @response.should redirect_to(resource(@poll_choice))
    end
  end
  
end

