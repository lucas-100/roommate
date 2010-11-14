When /^I make a payment$/ do
  Given 'I am logged in'
  visit new_payment_path
  fill_in "Amount", :with => '50'
  select "Bill"
  click_link_or_button "Create Payment"
  page.should have_content("Payment was successfully created.")
end

Then /^I should see that I don't owe anyone$/ do
  within "#oweMiddle .column_1" do
    page.should_not have_content("Bill: $50")
  end
end

Given /^I just made a payment$/ do
  Given 'there is a setup house'
  When 'I make a payment'
end

Then /^I should receive a payment confirmation$/ do
  unread_emails_for(current_email_address).size.should == 1
  open_email(current_email_address)
  current_email.should have_subject(/\[MyRoommate\] New payment sent to Bill/)
  current_email.should have_body_text(/\$50\.00/)
end
