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