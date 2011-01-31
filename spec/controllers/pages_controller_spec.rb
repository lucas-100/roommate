require 'spec_helper'

describe PagesController do
  
  describe "home #GET" do
    
    it "should assign @person" do
      person = Person.new
      Person.stub!(:new).and_return(person)
      
      get :home
      assigns[:person].should == person
    end
    
  end
  
end
