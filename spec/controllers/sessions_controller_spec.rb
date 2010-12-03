require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "assigns @person" do
      person = mock_model("Person").as_new_record
      Person.stub!(:new).and_return(person)
      get :new
      
      assigns[:person].should eq(person)
    end
  end
  
  describe "POST create" do
    it "assigns @person on failed login" do
       person = mock_model("Person").as_new_record
       Person.stub!(:new).and_return(person)
       Person.stub!(:authenticate).and_return(false)
       post :create
       
       assigns[:person].should eq(person)
    end
  end
end