require 'spec_helper'

describe Expense do
  before(:each) do
    @house = House.create!(:name => "Test House")
    @person = Person.create!(:name => "Jared", :email => "test@test.com", :password => "testtest", :password_confirmation => "testtest")
    @person.update_attribute(:house_id, @house.id)
    
    @expense = Expense.new(
      :name => "Rent",
      :amount_in_cents => 100,
      :people_array => {"#{@person.id}" => "1"},
      :loaner_id => @person.id,
      :amount_in_cents => 100,
      :creator_id => @person.id
    )
    @expense.house_id = @house.id
  end
  
  it "should be valid with valid attributes" do
    @expense.should be_valid
  end
  
  it "should not be valid without a name" do
    @expense.name = nil
    @expense.should_not be_valid
  end
  
  it "should not be valid without a loaner id" do
    @expense.loaner_id = nil
    @expense.should_not be_valid
  end
  
  it "should not be valid without at least one person" do
    @expense.people_array = {}
    @expense.should_not be_valid
  end
  
  it "should not be valid if the amount is less than zero" do
    @expense.amount_in_cents = 0
    @expense.should_not be_valid
  end
  
  it "creates people associations" do
    @expense.save
    @expense.people.count.should eq(1)
    @expense.people.should be_a(Array)
    @expense.people.first.name.should eq("Jared")
  end
  
  it "creates debt" do
    @expense.save
    @expense.debts.count.should eq(1)
    @expense.debts.first.should be_a(Debt)
  end
  
end