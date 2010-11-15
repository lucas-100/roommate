require 'spec_helper'

describe Person do
  before(:each) do
    @person = Person.new(
      :name => "Jared",
      :password => "password",
      :email => "jared.online@gmail.com",
      :password_confirmation => "password"
    )
  end
  
  it "should be valid with valid attributes" do
    @person.should be_valid
  end
  
  it "should be invalid without a name" do
    @person.name = nil
    @person.should_not be_valid
  end
  
  it "should be invalid without a password" do
    @person.password = nil
    @person.should_not be_valid
  end
  
  it "should be invalid with a short password" do
    @person.password = 'pas'
    @person.should_not be_valid
  end
  
  it "should be invalid with mismatching password and confirmation" do
    @person.password = "password"
    @person.password_confirmation = "somethingelse"
    @person.should_not be_valid
  end
  
  it "should be invalid without an email"
  
  it "should be invalid with a short email"
  
  it "should be invalid with an email that doesn't look like an email"
  
  it "should return all the debt it owes someone else"
  
  it "should return all the debt it loaned to someone else"
  
  it "has recent expenses"
  
  it "has recent loans"
  
  it "has recent payments made"
  
  it "has recent payments received"
  
  it "updates its password"
end