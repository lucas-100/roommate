require 'spec_helper'

describe PeopleController do
  describe "POST create" do
    let(:person) { mock_model(Person).as_null_object }
    
    before do
      Person.stub!(:new).and_return(person)
    end
    
    it "creates the person" do
      Person.should_receive(:new).with(
        "name" => "Jared", "email" => "jared.test@gmail.com", "password" => "password", "password_confirmation" => "password").and_return(person)
      
      post :create, {:person => {:name => "Jared", :email => "jared.test@gmail.com", :password => "password", :password_confirmation => "password"}}
    end
    
    it "assigns @person" do 
      Person.stub!(:new).and_return(person)
      post :create
      
      assigns[:person].should eq(person)
    end
    
    it "saves person" do
      person.should_receive(:save)
      
      post :create
    end
    
    context "successful save" do
      it "redirects to the wizard page" do
        post :create
        response.should redirect_to(house_wizard_path)
      end
      
      it "automatically logs the user in" do
        Person.should_receive(:authenticate)
        
        post :create
      end
      
      it "displays a confirmation" do
        post :create
        flash[:notice].should eq("Thank you for registering! You\'ve been automatically logged in.")
      end
    end
  end
  
  describe "POST search" do
    before(:each) do
      @current_person = mock_model("Person").as_null_object
      controller.stub!(:current_person).and_return(@current_person)
      controller.stub!(:login_required).and_return(:true)
    end
    
    it "looks for a person" do
      person = mock_model("Person").as_null_object
      Person.stub!(:where).and_return(person)
      
      post :search, {:person => {:email => "jared.online@gmail.com"}}
      assigns[:person].should eq(person)
    end
    
    context "successful search" do
      before(:each) do
        @person = mock_model("Person", :house_id => 1, :id => 1, :house => mock_model("House", :name => "Test House").as_null_object).as_null_object
        Person.stub!(:where).and_return(@person)
      end
      
      it "redirects to the dashboard" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        response.should redirect_to dashboard_path
      end
      
      it "assigns the house" do
        @current_person.should_receive(:update_attribute).with(:house_id, @person.id)
        post :search, {:person => {:email => "jared.online@gmail.com"}}
      end
      
      it "sets the flash notice" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        flash[:notice].should eq("You've been added to the 'Test House' house")
      end
    end
    
    context "unsuccessful search" do
      before(:each) do
        Person.stub!(:first).and_return(nil)
      end
      
      it "redirects to the wizard" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        response.should redirect_to house_wizard_path
      end
      
      it "sets the flash error" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        flash[:error].should eq("Couldn't find a user with that email.")
      end
    end
  end
end