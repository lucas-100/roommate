require 'spec_helper'

describe House do
  before(:each) do
    @house = House.new(:name => "Test House")
    @house.save
  end
  
  it "is valid with valid attributes" do
    @house.should be_valid
  end
  
  it "knows if there's no expenses" do
    @house.expenseless?.should eq(true)
  end
  
  it "knows if there's expenses" do
    person = Person.create(:name => "Test", :email => "test@test.com", :password => "password", :password_confirmation => "password")
    person.update_attribute(:house, @house)
    Expense.create(:loaner => person, :house => @house, :people_array => {"#{person.id}" => "1"}, :amount => 1, :name => "Test", :creator => person)
    @house.expenseless?.should eq(false)
  end
  
  it "knows if there's no payments" do
    @house.paymentless?.should eq(true)
  end
  
  it "knows if there's payments" do
    person = Person.create(:name => "Test", :email => "test@test.com", :password => "password", :password_confirmation => "password")
    person.update_attribute(:house, @house)
    Payment.create(:person_paid => person, :person_paying => person, :amount => 1, :house => @house)
    
    @house.paymentless?.should eq(false)
  end
  
  it "knows if there's no roommates" do
    @house.roommateless?.should eq(true)
  end
  
  it "knos if there's roommates" do
    (1..2).each do |i|
      Person.create(
        :name => "Test", 
        :email => "test#{i}@test.com", :password => "password", :password_confirmation => "password").update_attribute(:house, @house)
    end
    
    @house.roommateless?.should eq(false)
  end
end