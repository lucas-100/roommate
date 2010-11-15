require 'spec_helper'

describe 'person_mailer/new_expense_created.html.erb' do
  let(:expense) { mock_model("Expense", :amount => "2000").as_null_object }
  let(:debt) { mock_model("Debt", :amount => "500.00") }
  
  before do
    assign(:expense, expense)
    assign(:debt, debt)
  end
  
  it "should put each persons share of the expense in it" do
    render
    rendered.should contain("Your share is $500.00")
  end
end