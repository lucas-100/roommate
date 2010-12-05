Feature: wizard

	As a user
	I would like a wizard
	So that it's easier to register
	
	Scenario: after I've registered I need to add a house or join one
		Given I just signed up
		Then I should see "Do any of your roommates already have an account on MyRoommate?"
		
	Scenario: after I join a house I need to be brought to that house's dashboard
		Given there is a setup house
		And I just signed up
		When I join a house
		Then I should see "First time here?"
		And I should see "You've been added to the 'Test House' house"
	
	Scenario: attempt to join a house with a bad email
		Given I just signed up
		When I join a house
		Then I should see "Couldn't find a user with that email."
	
	Scenario: create a new house
		Given I just signed up
		When I create a new house
		Then I should see "New house created!"
	
	Scenario: after joining a house, prompt to create an expense
		Given I just signed up
		And I create a new house
		Then I should see "Click here to log your first expense"

	Scenario: after joining a house, prompt to create a payment
		Given I just signed up
		And I create a new house
		Then I should see "Click here to log your first payment"
	
	Scenario: after joining a house, prompt to add roommates
		Given I just signed up
		And I create a new house
		Then I should see "Click here to add a roommate"