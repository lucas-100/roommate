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
      it "redirects to the login page" do
        post :create
        response.should redirect_to(login_path)
      end
      
      it "displays a confirmation" do
        post :create
        flash[:notice].should eq("Thank you for registering! Login with your new account below.")
      end
    end
  end
end