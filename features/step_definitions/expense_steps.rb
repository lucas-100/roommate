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

When /^I log a new expense$/ do
  visit new_expense_path
  fill_in "Name", :with => "Rent"
  fill_in "Amount", :with => "2000"
  select "Jared"
  check "Jared"
  check "Phil"
  check "Bill"
  check "Josh"
  fill_in "Notes", :with => "Rent for this month"
  click_link_or_button "Create Expense"
  page.should have_content("Expense was successfully created.")
end

Then /^I should see who owe's me money$/ do
  page.should have_content("Bill: $500")
  page.should have_content("Josh: $500")
  page.should have_content("Phil: $500")
end

Given /^an expense was logged$/ do
  Given 'there is a setup house'
  And 'I am logged in'
  When 'I log a new expense'
end

Then /^I should get an email about the expense$/ do
  unread_emails_for(current_email_address).size.should == 1
  open_email(current_email_address)
  current_email.should have_subject(/\[MyRoommate\] New expense: Rent/)
  current_email.should have_body_text(/$2000.00/)
end