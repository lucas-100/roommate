Feature: Expenses

	As a user
	I would like to be able to log expenses
	So that I can keep track of who owe's me money
	
	Scenario: log a new expense
		Given there is a setup house
		And I am logged in
		When I log a new expense
		Then I should see who owe's me money
		
	Scenario: receive emails for expense
		Given an expense was logged
		Then I should get an email about the expense
		And everyone else should get an email about the expense
	
	Scenario: log a new expense where the person paying for it isn't responsible for it
		Given an expense was logged without me on it
		Then I should see "Expense was successfully created."