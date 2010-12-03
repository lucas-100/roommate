require 'spec_helper'

describe 'sessions/new.html.erb' do
  let(:person) { mock_model("Person").as_new_record.as_null_object }
  
  before do
    assign(:person, person)
  end
  
  it "should have the signup form" do
    render
    rendered.should have_selector("form", :action => "/people") do |form|
      form.should have_selector("input", :id => "person_name")
      form.should have_selector("input", :id => "person_email")
      form.should have_selector("input", :id => "person_password")
      form.should have_selector("input", :id => "person_password_confirmation")
    end
  end
end