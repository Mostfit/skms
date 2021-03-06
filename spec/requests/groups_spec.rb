require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a group exists" do
  Group.all.destroy!
  request(resource(:groups), :method => "POST", 
    :params => { :group => { :id => nil }})
end

describe "resource(:groups)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:groups))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of groups" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a group exists" do
    before(:each) do
      @response = request(resource(:groups))
    end
    
    it "has a list of groups" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Group.all.destroy!
      @response = request(resource(:groups), :method => "POST", 
        :params => { :group => { :id => nil }})
    end
    
    it "redirects to resource(:groups)" do
      @response.should redirect_to(resource(Group.first), :message => {:notice => "group was successfully created"})
    end
    
  end
end

describe "resource(@group)" do 
  describe "a successful DELETE", :given => "a group exists" do
     before(:each) do
       @response = request(resource(Group.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:groups))
     end

   end
end

describe "resource(:groups, :new)" do
  before(:each) do
    @response = request(resource(:groups, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@group, :edit)", :given => "a group exists" do
  before(:each) do
    @response = request(resource(Group.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@group)", :given => "a group exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Group.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @group = Group.first
      @response = request(resource(@group), :method => "PUT", 
        :params => { :group => {:id => @group.id} })
    end
  
    it "redirect to the group show action" do
      @response.should redirect_to(resource(@group))
    end
  end
  
end

