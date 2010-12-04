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
		
	Scenario: signup
	  Given I am on the homepage
	  When I fill in the following:
	    | person_email | jared.test@gmail.com |
	    | person_name | Jared Test |
	    | person_password | password |
	    | person_password_confirmation | password |
	  And I press "Sign Up"
	  Then I should see "Thank you for registering! You've been automatically logged in."
		
	Scenario: automatically logged in after signup
		Given I just signed up
		Then I should see "Logout"