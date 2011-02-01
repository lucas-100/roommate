Feature: Roommates
	
	As a user
	I want to be able to add roommates
	So that I can start tracking expense and payments
	
	Scenario: Add a new roommate
		Given there is a setup house with payment and expense history
		And I am logged in
		And I am on the add roommate page
		When I fill in "person_name" with "Jared"
		And I fill in "person_email" with "jared.test45@test.com"
		And I press "Create Roommate"
		Then I should see "You added Jared (jared.test45@test.com) as a roommate!"