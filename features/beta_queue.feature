Feature: beta queue

	Given I am a visitor
	I want to enter the beta queue
	So that I can have access to the site
	
	Scenario: Signup
		Given I am on the login page
		When I fill in the following:
			| signup_email | jared.online@gmail.com |
			| signup_name | Jared McFarland |
		And I press "Sign Up"
		Then I should see "Thanks for signing up!"