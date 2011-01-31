require 'spec_helper'

describe 'pages/home.html.erb' do
  let(:person) {
    mock_model("Person").as_null_object
  }
  
  before do
    person.stub!(:new_user? => :true)
    assign(:person, person)
  end
  
  it "shows the login form" do
    render
    
    rendered.should have_selector(:form) do |form|
      form.should have_selector(:input, :id => 'email')
      form.should have_selector(:input, :id => 'password')
    end
  end
  
  it "shows the register form" do
    render
    
    rendered.should have_selector(:form) do |form|
      form.should have_selector(:input, :id => 'person_email')
      form.should have_selector(:input, :id => 'person_password')
      form.should have_selector(:input, :id => 'person_password_confirmation')
      form.should have_selector(:input, :id => 'person_name')
    end
  end
  
  it "has the my roommate header" do
    pending
    render
    
    rendered.should have_selector(:h1) do |h1|
      h1.should contain("MyRoommate")
    end
  end
  
  it "shows an explanation"
end