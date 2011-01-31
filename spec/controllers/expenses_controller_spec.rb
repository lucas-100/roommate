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
  
  describe "GET show" do
    it "assigns @expense" do
      expense = mock_model(Expense).as_null_object
      Expense.stub!(:where).and_return(expense)
      get :show, {:id => 1}
      assigns[:expense].should eq(expense)
    end
  end
  
  describe "GET new" do
    it "assigns @expense" do
      expense = mock_model(Expense).as_null_object
      Expense.stub!(:new).and_return(expense)
      
      get :new
      assigns[:expense].should eq(expense)
    end
    
    it "assigns @people" do
      people = mock_model(Person).as_null_object
      @house.stub!(:people).and_return(people)
      
      get :new
      assigns[:people].should eq(people)
    end
  end
  
  describe "GET edit" do
    let(:expense) { mock_model(Expense).as_null_object }
    
    before(:each) do
      Expense.stub!(:where).and_return(expense)
    end
    
    it "assigns @expense" do
      get :edit, {:id => 1}
      assigns[:expense].should eq(expense)
    end
    
    it "assigns @people" do
      people = mock_model(Person).as_null_object
      Person.stub!(:where).and_return(people)
      
      get :edit, {:id => 1}
      assigns[:people].should eq(people)
    end
  end
  
  describe "POST create" do
    let(:expense) { mock_model(Expense).as_null_object }
    
    before do
      Expense.stub!(:new).and_return(expense)
    end
    
    it "creates a new expense" do
      Expense.should_receive(:new).with({"name" => "Rent", "loaner_id" => 1, "people_array" => {"1" => "1"}, "amount_in_cents" => 100}).and_return(expense)
      
      post :create, {:expense => {"name" => "Rent", "loaner_id" => 1, "people_array" => {"1" => "1"}, "amount_in_cents" => 100}}
    end
    
    it "saves the expense" do
      expense.should_receive(:save)
      
      post :create
    end
    
    it "assigns @expense" do
      post :create, {:expense => {:name => "Rent", :loaner_id => 1, :people_array => {"1" => "1"}, :amount_in_cents => 100}}
      
      assigns[:expense].should eq(expense)
    end
    
    context "on successful save" do
      it "redirects to the homepage" do
        post :create
        response.should redirect_to(dashboard_path)
      end
      
      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should eq("Expense was successfully created.")
      end
    end
    
    context "on unsuccessful save" do
      it "renders the new template" do
        expense.stub(:save).and_return(false)
        post :create
        response.should render_template("new")
      end
    end
  end
  
  describe "POST update" do
    let(:expense) { mock_model(Expense).as_null_object }
    
    before(:each) do
      Expense.stub!(:where).and_return(expense)
    end
    
    it "assigns @expense" do
      post :update, {:id => 1}
      assigns[:expense].should eq(expense)
    end
    
    it "updates the attributes" do
      expense.should_receive(:update_attributes)
      
      post :update, {:id => 1}
    end
    
    context "on successful update" do
      it "redirects to the expense" do
        post :update, {:id => 1}
        response.should redirect_to(expense_path(expense))
      end
      
      it "sets a flash[:notice] message" do
        post :update, {:id => 1}
        flash[:notice].should eq("Expense was successfully updated.")
      end
    end
    
    context "on unsuccessful update" do
      it "renders the edit template" do
        expense.stub(:update_attributes).and_return(false)
        post :update, {:id => 1}
        response.should render_template("edit")
      end
    end
  end
  
  describe "DELETE destroy" do
    let(:expense) { mock_model(Expense).as_null_object }
    
    before(:each) do
      Expense.stub!(:where).and_return(expense)
    end
    
    it "assigns @expense" do
      delete :destroy, {:id => 1}
      assigns[:expense].should eq(expense)
    end
    
    it "deletes @expense" do
      expense.should_receive(:destroy)
      delete :destroy, {:id => 1}
    end
    
    it "redirects to root" do
      delete :destroy, {:id => 1}
      response.should redirect_to(dashboard_path(:anchor => "expenses"))
    end
  end
end