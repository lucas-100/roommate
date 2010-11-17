require 'spec_helper'

describe PersonMailer do
  let(:expense) { mock_model("Expense", :amount => "2000", :name => "Test").as_null_object }
  let(:person) { mock_model("Person", :email => "jared.online@gmail.com").as_null_object }
  let(:payment) { mock_model("Payment").as_null_object }
  let(:pass) { "Password" }
  
  before do
    @expense = expense
    @person = person
    @payment = payment
    @pass = pass
  end
  
  it "should send new expense emails" do
    PersonMailer.new_expense_created(@expense, @person)
  end
  
  it "should send new payment emails" do
    PersonMailer.new_payment_sent(@payment, @person)
  end
  
  it "should send new payment received emails" do
    PersonMailer.new_payment_received(@payment, @person)
  end
  
  it "should send new person created emails" do
    PersonMailer.new_person_created(@person, @pass)
  end
  
end