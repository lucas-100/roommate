Given /^there is a user and a house$/ do
  house = House.create(:name => "Test House")
  person = Person.create(:email => "jared.online@gmail.com", :password => "password", :password_confirmation => "password", :name => "Jared")
  person.update_attribute(:house_id, house.id)
end

Given /^I am logged in$/ do
  visit '/'
  fill_in "email", :with => "jared.online@gmail.com"
  fill_in "Password", :with => "password"
  click_link_or_button "Log In"
end

When /^change my account settings$/ do
  fill_in "person_name", :with => "Test"
  fill_in "person_email", :with => "test@test.com"
  click_link_or_button "Save Profile"
end

When /^I change my password$/ do
  fill_in "person_password", :with => "test"
  fill_in "person_password_confirmation", :with => "test"
  click_link_or_button "Save Password"
end

Then /^I should be able to login with the new password$/ do
  click_link_or_button "Logout"
  fill_in "email", :with => "jared.online@gmail.com"
  fill_in "Password", :with => "test"
  click_link_or_button "Log In"
  page.should have_content("Welcome back, Jared")
end
