require 'spec_helper'

describe "wizard/house.html.erb" do
  it "should prompt to enter an email" do
    render
    rendered.should have_selector("form", :action => "/people/search", :method => "post") do |form|
      form.should have_selector("label") do |label|
        label.should contain("Email")
      end
      
      form.should have_selector("input", :id => "person_email")
      
      form.should have_selector("button")
    end
  end
  
  it "should prompt to create a new house" do
    render
    rendered.should have_selector("form", :action => "/houses") do |form|
      form.should have_selector("button")
    end
  end
  
  it "should have a clear seperation between the two choices" do
    render
    rendered.should have_selector("div", :class => "roommate-lookup")
    rendered.should have_selector("div", :class => "start-new-house")
  end
end