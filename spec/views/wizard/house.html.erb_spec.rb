require 'spec_helper'

describe "wizard/house.html.erb" do
  it "should prompt to enter an email" do
    render
    rendered.should have_selector("form", :action => "/people/search", :method => "post") do |form|
      form.should have_selector("label") do |label|
        label.should contain("Enter a roommates email")
      end
      
      form.should have_selector("input", :id => "person_email")
      
      form.should have_selector("button")
    end
  end
  
  it "should prompt to create a new house" do
    render
    rendered.should have_selector("a", :href => "/houses/new") do |a|
      a.should contain("No, I'm the first of my roommates to sign up for MyRoomate.")
    end
  end
  
  it "should have a clear seperation between the two choices"
end