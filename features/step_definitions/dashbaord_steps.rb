Then /^Bill should owe me \$(\d+)$/ do |amount|
  visit root_path
  within "#oweMiddle .column_2" do
    page.should have_content("Bill: $#{amount}")
  end
  within "#oweMiddle .column_1" do
    page.should_not have_content("Bill")
  end
end

Then /^I should owe Phil and Josh \$(\d+) each$/ do |amount|
  visit root_path
  within "#oweMiddle .column_1" do
    page.should have_content("Josh: $#{amount}")
    page.should have_content("Phil: $#{amount}")
  end
  within "#oweMiddle .column_2" do
    page.should_not have_content("Josh")
    page.should_not have_content("Phil")
  end
end

Then /^I should see the things I paid for$/ do
  visit root_path
  within "#expenses .column_2" do
    page.should have_content("Rent")
    page.should have_content("$2000.00")
  end
  within "#expenses .column_1" do
    page.should_not have_content("Rent")
    page.should_not have_content("$2000.00")
  end
end

Then /^I should see the things I didn't pay for$/ do
  visit root_path
  within "#expenses .column_2" do
    page.should_not have_content("Groceries")
    page.should_not have_content("Electric Bill")
  end
  within "#expenses .column_1" do
    page.should have_content("Groceries")
    page.should have_content("Phil")
    page.should have_content("Electric Bill")
    page.should have_content("Bill")
  end
end

Then /^I should see the people who paid me$/ do
  within "#payments .column_2" do
    page.should have_content("Phil")
    page.should have_content("Bill")
    page.should have_content("Josh")
  end
end

Then /^I should see the people I paid$/ do
  within "#payments .column_1" do
    page.should have_content("Phil")
  end
end

Then /^I should see all my roommates$/ do
  page.should have_content("Phil")
  page.should have_content("Bill")
  page.should have_content("Jared")
  page.should have_content("Josh")
end