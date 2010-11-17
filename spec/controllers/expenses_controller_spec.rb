require 'spec_helper'

describe ExpensesController do
  before(:each) do
    @house = mock_model("House").as_null_object
    @person = mock_model("Person", :house => @house, :expenses => mock_model("Expense").as_null_object).as_null_object
    
    controller.stub!(:current_person).and_return(@person)
    controller.stub!(:login_required).and_return(:true)
  end
  
  describe "GET index" do
    it "assigns @expenses" do
      get :index
      
      assigns[:expenses].should eq(@person.expenses)
    end
  end
end