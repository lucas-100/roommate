require 'spec_helper'

describe PeopleController do
  describe "GET new" do
    it "assigns @new_person" do
      person = mock_model(Person).as_null_object
      @house = mock_model(House, :id => 1)
      controller.stub!(:load_house).and_return(@house)
      Person.stub!(:new).and_return(person)
      get :new

      assigns[:new_person].should eq(person)
    end
  end

  describe "POST add_roommate" do
    let(:person) { mock_model(Person, :house_id => 1, :email => "foo@example.com").as_null_object }

    before do
      Person.stub!(:new).and_return(person)
      @current_person = mock_model("Person", :house_id => 1).as_null_object
      controller.stub!(:current_person).and_return(@current_person)
      controller.stub!(:person_required).and_return(:true)
      @house = mock_model(House, :id => 1)
      controller.stub!(:load_house).and_return(@house)
      person.stub!(:save).and_return(true)
    end

    it "should save new_person" do
      person.should_receive(:save)
      post :add_roommate, {:person => {:name => "Jared", :email => "jared.online@gmail.com"}}
    end

    it "assigns the house_id" do
      post :add_roommate, {:person => {:name => "Jared", :email => "jared.online@gmail.com"}}
      person.house_id.should eq(@current_person.house_id)
    end

    context "successful save" do
      it "redirects to the dashboard page" do
        post :add_roommate, {:person => {:name => "Jared", :email => "jared.online@gmail.com"}}
        response.should redirect_to(dashboard_path)
      end

      it "displays a confirmation" do
        post :add_roommate, {:person => {:name => "Jared", :email => "jared.online@gmail.com"}}
        flash[:notice].should eq("You added Jared (jared.online@gmail.com) as a roommate!")
      end
    end
  end

  describe "POST create" do
    let(:person) { mock_model(Person).as_null_object }

    before do
      Person.stub!(:new).and_return(person)
      person.stub!(:save).and_return(true)
    end

    it "creates the person" do
      Person.should_receive(:new).with(
        "name" => "Jared", "email" => "jared.test@gmail.com", "password" => "password", "password_confirmation" => "password").and_return(person)

      post :create, {:person => {:name => "Jared", :email => "jared.test@gmail.com", :password => "password", :password_confirmation => "password"}}
    end

    it "assigns @person" do 
      Person.stub!(:new).and_return(person)
      post :create

      assigns[:person].should eq(person)
    end

    it "saves person" do
      person.should_receive(:save)

      post :create
    end

    context "successful save" do
      it "redirects to the wizard page" do
        post :create
        response.should redirect_to(house_wizard_path)
      end

      it "automatically logs the user in" do
        PersonSession.should_receive(:create)

        post :create
      end

      it "displays a confirmation" do
        post :create
        flash[:notice].should eq("Thank you for registering! You\'ve been automatically logged in.")
      end
    end
  end

  describe "POST search" do
    before(:each) do
      @current_person = mock_model("Person").as_null_object
      controller.stub!(:current_person).and_return(@current_person)
      controller.stub!(:person_required).and_return(:true)
    end

    it "looks for a person" do
      house = mock_model("House", :name => "Test House")
      person = mock_model("Person", :house => house).as_null_object
      Person.stub_chain(:where, :limit, :first).and_return(person)

      post :search, {:person => {:email => "jared.online@gmail.com"}}
      assigns[:person].should eq(person)
    end

    context "successful search" do
      before(:each) do
        @person = mock_model("Person", :house_id => 1, :id => 1, :house => mock_model("House", :name => "Test House").as_null_object).as_null_object
        Person.stub_chain(:where, :limit, :first).and_return(@person)
      end

      it "redirects to the dashboard" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        response.should redirect_to dashboard_path
      end

      it "assigns the house" do
        @current_person.should_receive(:update_attribute).with(:house_id, @person.id)
        post :search, {:person => {:email => "jared.online@gmail.com"}}
      end

      it "sets the flash notice" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        flash[:notice].should eq("You've been added to the 'Test House' house")
      end
    end

    context "unsuccessful search" do
      before(:each) do
        Person.stub!(:first).and_return(nil)
      end

      it "redirects to the wizard" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        response.should redirect_to house_wizard_path
      end

      it "sets the flash error" do
        post :search, {:person => {:email => "jared.online@gmail.com"}}
        flash[:error].should eq("Couldn't find a user with that email.")
      end
    end
  end
end
