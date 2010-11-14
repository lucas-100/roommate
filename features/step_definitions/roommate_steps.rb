def current_email_address
  @email || (@current_user && @current_user.email) || "jared.online@gmail.com"
end

Given /^there is a setup house$/ do
  @house = House.create!(:name => "Test House")
  bill = Person.create(:name => "Bill", :email => "bill@testemail.com", :password => "password", :password_confirmation => "password")
  bill.update_attribute(:house_id, @house.id)
  
  phil = Person.create(:name => "Phil", :email => "phil@testemail.com", :password => "password", :password_confirmation => "password")
  phil.update_attribute(:house_id, @house.id)
  
  josh = Person.create(:name => "Josh", :email => "josh@testemail.com", :password => "password", :password_confirmation => "password")
  josh.update_attribute(:house_id, @house.id)
  
  jared = Person.create(:name => "Jared", :email => "jared.online@gmail.com", :password => "password", :password_confirmation => "password")
  jared.update_attribute(:house_id, @house.id)
end

Given /^there is a user and a house$/ do
  house = House.create(:name => "Test House")
  person = Person.create(:email => "jared.online@gmail.com", :password => "password", :password_confirmation => "password", :name => "Jared")
  person.update_attribute(:house_id, house.id)
end

Given /^there is a setup house with payment and expense history$/ do
  Given 'there is a setup house'
  Given 'the house has payment and expense history'
end

Given /^the house has payment and expense history$/ do
  expense = Expense.new(:name => "Rent", :amount_in_cents => 200000, :payer_id => 4, :loaner_id => 4, :creator_id => 4, :house_id => 1)
  expense.people << Person.all
  expense.people_array = {"1" => "1"}
  expense.save
  
  Payment.create!(:amount_in_cents => 30000, :person_paid_id => 4, :person_paying_id => 1)
  Payment.create!(:amount_in_cents => 50000, :person_paid_id => 4, :person_paying_id => 2)
  Payment.create!(:amount_in_cents => 50000, :person_paid_id => 4, :person_paying_id => 3)
  
  expense = Expense.new(:name => "Groceries", :amount_in_cents => 80000, :payer_id => 2, :loaner_id => 2, :house_id => 1, :creator_id => 4)
  expense.people << Person.all
  expense.people_array = {"1" => "1"}
  expense.save
  
  Payment.create!(:amount_in_cents => 10000, :person_paid_id => 2, :person_paying_id => 4)
  
  expense = Expense.new(:name => "Electric Bill", :amount_in_cents => 40000, :payer_id => 3, :loaner_id => 3, :house_id => 1, :creator_id => 4)
  expense.people << Person.all
  expense.people_array = {"1" => "1"}
  expense.save
end