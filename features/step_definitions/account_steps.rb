Given /^I am logged in$/ do
  visit '/'
  fill_in "email", :with => "jared.online@gmail.com"
  fill_in "password", :with => "password"
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
  fill_in "password", :with => "test"
  click_link_or_button "Log In"
  page.should have_content("Welcome back, Jared")
end

Given /^I just signed up$/ do
  Given "I am on the homepage"
  When 'I fill in "person_email" with "jared.test@gmail.com"'
  When 'I fill in "person_name" with "Phillip"'
  When 'I fill in "person_password" with "password"'
  When 'I fill in "person_password_confirmation" with "password"'
  When 'I press "Sign Up"'
  Then 'I should see "Thank you for registering! Login with your new account below."'
end

When /^I sign in$/ do
  visit '/session/new'
  fill_in "email", :with => "jared.test@gmail.com"
  fill_in "password", :with => "password"
  click_link_or_button "Log In"
end
