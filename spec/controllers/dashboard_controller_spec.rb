require 'spec_helper'

describe DashboardController do
  describe "GET index" do
    it "finds the current house" do
      house = mock_model(House)
      House.stub!(:find).and_return(house)
    end
    
    it "gets the current person" do
      person = mock_model(Person)
      Person.stub!(:find).and_return(person)
    end
  end
end