Given /^I join a house$/ do
  fill_in "person_email", :with => "jared.online@gmail.com"
  click_link_or_button "Find Person"
end

When /^I create a new house$/ do
  click_link_or_button "Start a new house"
end
