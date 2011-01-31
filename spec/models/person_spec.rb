require 'spec_helper'

describe Person do
  before(:each) do
    @person = Person.new(
      :name => "Jared McFarland",
      :password => "password",
      :email => "jared.online@gmail.com",
      :password_confirmation => "password"
    )
  end
  
  it "should be valid with valid attributes" do
    @person.should be_valid
  end
  
  it "should return a 1 word first name" do
    @person.first_name.split(" ").count.should eq(1)
  end
  
  it "should be invalid without a name" do
    @person.name = nil
    @person.should_not be_valid
  end
  
  it "should be invalid without a password" do
    @person.password = nil
    @person.should_not be_valid
  end
  
  it "should be invalid with a short password" do
    @person.password = 'pas'
    @person.should_not be_valid
  end
  
  it "should be invalid with mismatching password and confirmation" do
    @person.password = "password"
    @person.password_confirmation = "somethingelse"
    @person.should_not be_valid
  end
  
  it "should be invalid without an email" do
    @person.email = nil
    @person.should_not be_valid
  end
  
  it "should be invalid with a short email" do
    @person.email = 'jar'
    @person.should_not be_valid
  end
  
  it "should be invalid with an email that doesn't look like an email" do
    @person.email = 'jaredjaredjared'
    @person.should_not be_valid
  end
  
  it "updates its password" do
    @person.save
    @person.should_receive(:update_attribute)
    
    @person.update_password({:password => "newpassword", :password_confirmation => "newpassword"}).should_not == false
  end
  
  it "doesn't update the password if they don't match" do
    @person.save
    @person.errors.should_receive(:add)
    
    @person.update_password({:password => "newpassword", :password_confirmation => "testpassword" }).should == false
  end
  
  it "doesn't update the password if it's blank" do
    @person.save
    @person.errors.should_receive(:add)
    
    @person.update_password({:password => "", :password_confirmation => "" }).should == false
  end
  
  it "knows if its a new user" do
    @house = House.create!(:name => "Test House")
    @person.update_attribute(:house, @house)
    
    @person.new_user?.should == true
  end
  
  it "knows if its not a new user" do
    @house = House.create!(:name => "Test House")
    @person.update_attribute(:house, @house)
    @person.payments_made << Payment.create!(:amount => 100, :person_paid_id => 2, :person_paying_id => 1)
    
    @person.new_user?.should == false
  end
  
  context "when there's been some user interaction" do 
    before(:each) do
      house = House.create!
      @person.house = house
      @person.save
      person2 = Person.create(
        :name => "Phil",
        :email => "phil@testemail.com",
        :password => "password",
        :password_confirmation => "password"
      )
      person2.update_attribute(:house, house)
    end
    
    it "should return all the debt it owes someone else" do
      e = Expense.new(:name => "Rent", :loaner_id => 2, :house_id => 1, :amount_in_cents => 20000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
    
      debt = @person.all_debts_owed
      debt.should be_a(Array)
      debt[0][:amount].should be_a(Money)
      debt.count.should == 1
    end
  
    it "should return all the debt it loaned to someone else" do
      e = Expense.new(:name => "Rent", :loaner_id => 1, :house_id => 1, :amount_in_cents => 20000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
    
      debt = @person.all_debts_loaned
      debt.should be_a(Array)
      debt[0][:amount].should be_a(Money)
      debt.count.should == 1
    end
  
    it "has recent expenses" do
      e = Expense.new(:name => "Rent", :loaner_id => 2, :house_id => 1, :amount_in_cents => 20000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
      
      expenses = @person.recent_expenses
      expenses.should be_a(Array)
      expenses[0].should be_a(Expense)
      expenses.should == expenses.uniq
      expenses.count.should == 1
    end
  
    it "has recent loans" do
      e = Expense.new(:name => "Rent", :loaner_id => 1, :house_id => 1, :amount_in_cents => 20000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
      
      loans = @person.recent_loans
      loans.should be_a(Array)
      loans[0].should be_a(Expense)
      loans.count.should == 1
    end
  
    it "has recent payments made" do
      Payment.create!(:amount_in_cents => 100, :person_paying_id => 1, :person_paid_id => 2)
      
      payments = @person.recent_payments_made
      payments.should be_a(Array)
      payments[0].should be_a(Hash)
      payments.count.should == 1
    end
  
    it "has recent payments received" do
      Payment.create!(:amount_in_cents => 100, :person_paying_id => 2, :person_paid_id => 1)
      
      payments = @person.recent_payments_received
      payments.should be_a(Array)
      payments[0].should be_a(Hash)
      payments.count.should == 1
    end
  end
  
  context "when there's been a lot of user interaction" do
    before(:each) do
      house = House.create!
      @person.house = house
      @person.save
      person2 = Person.create(
        :name => "Phil",
        :email => "phil@testemail.com",
        :password => "password",
        :password_confirmation => "password"
      )
      person2.update_attribute(:house, house)
      
      person3 = Person.create(
        :name => "Bill",
        :email => "bill@testemail.com",
        :password => "password",
        :password_confirmation => "password"
      )
      person3.update_attribute(:house, house)
      
      e = Expense.new(:name => "Rent", :loaner_id => 1, :house_id => 1, :amount_in_cents => 300000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
      
      Payment.create!(:amount_in_cents => 100000, :person_paid_id => 1, :person_paying_id => 2)
      
      e = Expense.new(:name => "Groceries", :loaner_id => 2, :house_id => 1, :amount_in_cents => 30000, :people_array => {"1" => "1"}, :creator_id => 1)
      e.people << Person.all
      e.save
      
      Payment.create!(:amount_in_cents => 5000, :person_paid_id => 2, :person_paying_id => 1)
      
      # person 1 owe's person 2 $50
      # person 3 owe's person 1 $1000
    end
    
    it "should calculate how much it owes each person" do
      @person.all_debts_owed.count.should == 1
      @person.all_debts_owed[0][:amount].cents.should == 5000
      @person.all_debts_owed[0][:person].should == "Phil"
      
      @person.all_debts_loaned.count.should == 1
      @person.all_debts_loaned[0][:amount].cents.should == 100000
      @person.all_debts_loaned[0][:person].should == "Bill"
    end
  end
end