Feature: User accounts

	As a user
	I want to have an account
	So that I can keep track of my personal debts and expense
	
	Scenario: login
		Given I am on the login page
		And there is a user and a house
		When I fill in the following:
			| email | jared.online@gmail.com |
			| password | password |
		And I press "Log In"
		Then I should see "Welcome back, Jared"
	
	Scenario: logout
		Given there is a user and a house
		And I am logged in
		When I follow "Logout"
		Then I should see "You have been logged out."
		
	Scenario: change name and email
		Given there is a user and a house
		And I am logged in
		When I follow "Account"
		And change my account settings
		Then I should see "Profile was successfully updated."
		
	Scenario: change password
		Given there is a user and a house
		And I am logged in
		When I follow "Account"
		And I change my password
		Then I should see "Profile was successfully updated."
		And I should be able to login with the new password