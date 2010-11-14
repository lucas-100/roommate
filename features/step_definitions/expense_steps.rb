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

Given /^an expense from a roommate was logged$/ do
  expense = Expense.new(:name => "Electricity", :amount_in_cents => 20000, :notes => "Electric for this month", :payer_id => 1, :loaner_id => 1)
  expense.people << Person.all
  expense.save
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
  current_email.should have_body_text(/\$2000\.00/)
  current_email.should have_body_text(/Jared created a new expense\, that they paid for/)
end

Then /^everyone else should get an email about the expense$/ do
  unread_emails_for('bill@testemail.com').size.should == 1
  open_email('bill@testemail.com')
  current_email.should have_subject(/\[MyRoommate\] New expense: Rent/)
  current_email.should have_body_text(/\$2000\.00/)
  current_email.should have_body_text(/Jared created a new expense\, that they paid for/)
  
  unread_emails_for('phil@testemail.com').size.should == 1
  open_email('phil@testemail.com')
  current_email.should have_subject(/\[MyRoommate\] New expense: Rent/)
  current_email.should have_body_text(/\$2000\.00/)
  current_email.should have_body_text(/Jared created a new expense\, that they paid for/)
  
  unread_emails_for('josh@testemail.com').size.should == 1
  open_email('josh@testemail.com')
  current_email.should have_subject(/\[MyRoommate\] New expense: Rent/)
  current_email.should have_body_text(/\$2000\.00/)
  current_email.should have_body_text(/Jared created a new expense\, that they paid for/)
end
