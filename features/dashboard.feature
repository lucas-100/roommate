Feature: Dashboard
	
	As a user
	I want to have a dashboard
	So that I can see an overview of who I owe/who owe's me, quickly
	
	Scenario: see who I owe
		Given there is a setup house with payment and expense history
		And I am logged in
		Then I should owe Phil and Josh $100 each
	
	Scenario: see who owe's me
		Given there is a setup house with payment and expense history
		And I am logged in
		Then Bill should owe me $200
		
	Scenario: see things I paid for recently
		Given there is a setup house with payment and expense history
		And I am logged in
		Then I should see the things I paid for
		
	Scenario: see things I didn't pay for recently
		Given there is a setup house with payment and expense history
		And I am logged in
		Then I should see the things I didn't pay for
		
	Scenario: see people who paid me recently
		Given there is a setup house with payment and expense history
		And I am logged in
		Then I should see the people who paid me
		
	Scenario: see people I paid recently
		Given there is a setup house with payment and expense history
		And I am logged in
		Then I should see the people I paid
		
	Scenario: see the people who live with me
		Given there is a setup house
		And I am logged in
		Then I should see all my roommates