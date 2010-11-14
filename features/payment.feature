Feature: Payment feature

	As a user
	I should be able to make payments
	To keep track of who I've paid
	
	Scenario: make a payment
		Given there is a setup house
		And an expense from a roommate was logged
		When I make a payment
		Then I should see that I don't owe anyone
	
	Scenario: receive payment emails
		Given I just made a payment
		Then I should receive a payment confirmation