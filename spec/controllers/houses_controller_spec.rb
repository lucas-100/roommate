require 'spec_helper'

describe HousesController do
  describe "POST create" do
    before(:each) do
      @current_person = mock_model("Person").as_null_object
      controller.stub!(:current_person).and_return(@current_person)
      controller.stub!(:person_required).and_return(:true)
      @house = mock_model("House", :id => 1).as_null_object
      House.stub!(:new).and_return(@house)
    end
    
    it "should create a new house" do
      @house.should_receive(:save)
      
      post :create
    end
    
    it "should assign the new house to the current user" do
      @current_person.should_receive(:update_attribute).with(:house_id, @house.id)
      
      post :create
    end
    
    it "should redirect to the dashboard" do
      post :create
      
      response.should redirect_to(dashboard_path)
    end
    
    it "should set the flash message" do
      post :create
      
      flash[:notice].should eq("New house created!")
    end
  end
end
