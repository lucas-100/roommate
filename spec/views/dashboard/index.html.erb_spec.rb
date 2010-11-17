require 'spec_helper'

describe "dashboard/index.html.erb" do
  let(:person) { 
    mock_model("Person", 
                :name => "Jared", 
                :email => "jared.online@gmail.com", 
                :recent_expenses => [mock_model("Expense", 
                                                  :name => "Electricity", 
                                                  :created_at => Time.now, 
                                                  :loaner => mock_model("Person", :name => "Bill Duncan", :first_name => "Bill").as_null_object
                                                ).as_null_object]
                ).as_null_object 
  }
  let(:house) { mock_model("House", :name => "Test House").as_null_object }
  
  before do
    assign(:person, person)
    assign(:house, house)
  end
  
  it "should have the name of the house" do
    render
    rendered.should contain("Test House")
  end
  
  it "should have a new expense button" do
    render
    rendered.should have_selector("a", :href => new_expense_path)
  end
  
  it "should have a new payment button" do
    render
    rendered.should have_selector("a", :href => new_payment_path)
  end
  
  it "should have who I owe" do
    render
    rendered.should contain("Who I owe")
  end
  
  it "should have who owes me" do
    render
    rendered.should contain("Who owes me")
  end
  
  it "should have recent payments" do
    render
    rendered.should contain("People I paid")
    rendered.should contain("People who paid me")
  end
  
  it "should have recent expenses" do
    render
    rendered.should contain("Things I paid for")
    rendered.should contain("Things I didn't pay for")
  end
  
  it "should have an edit link for the house name" do 
    render
    rendered.should have_selector("a", :href => edit_house_path(house))
  end
    
  it "should say the name of the person who paid for something" do
    render
    rendered.should have_selector("div", :id => "expenses") do |expenses_div|
      expenses_div.should have_selector("div", :class => "column_1") do |column_1|
        column_1.should contain("Bill")
        column_1.should_not contain("Duncan")
      end
    end
  end
  
end