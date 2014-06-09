require 'digest'

class PeopleController < ApplicationController
  before_filter :person_required, :except => [:new, :create, :add_roommate]

  # TODO - before_filter :load_house
  respond_to :json
  respond_to :html

  # GET /people
  # GET /people.xml
  def index
    house = current_person.house
    @people = []
    house.people.each do |person|
      if person != current_person
        @people << {:name => person.name}
      end
    end

    respond_with(@people)
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    person = house.people.find(params[:id])
    respond_to do |format|
      format.json do
        res = Jbuilder.encode do |json|
          json.person do |per|
            per.id    person.id
            per.house house.id
            per.name  person.name
          end
        end

        render :json => res
      end
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @new_person = Person.new
    respond_with(@house, @new_person)
  end

  def signup

  end

  # POST /people/add_roommate
  def add_roommate
    new_person       = Person.new(params[:person])
    new_person.house = @house

    password = Digest::MD5.hexdigest("#{@person.name}#{@person.email}#{Time.now}")[0..8]

    new_person.password              = password
    new_person.password_confirmation = password

    PersonMailer.new_person_created(new_person, password).deliver

    if new_person.save
      redirect_to(dashboard_path, :notice => "You added #{params[:person][:name]} (#{params[:person][:email]}) as a roommate!")
    else
      flash[:error] = "Unable to add roommate"
      render :new
    end
  end

  # GET /people/1/edit
  def edit

  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        @person_session = PersonSession.create(@person, false, true)

        format.html { redirect_to(house_wizard_path, :notice => 'Thank you for registering! You\'ve been automatically logged in.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        flash[:error] = "Unable to sign you up."
        format.html { render :template => "signups/new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def signup

  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(account_path, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        flash[:error] = "We couldn't save your profile."
        format.html { render :action => "show" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update_password
    respond_to do |format|
      if @person.update_password(params[:person])
        format.html { redirect_to(account_path, :notice => 'Your password was successfully changed.') }
        format.xml  { head :ok }
      else
        flash[:error] = "We couldn't save your profile."
        format.html { render :action => "show" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /people/search
  def search
    @person = Person.where(:email => params[:person][:email]).limit(1).first

    if @person
      house = @person.house
      current_person.update_attribute(:house_id, @person.house_id)
      redirect_to(dashboard_path, :notice => "You've been added to the '#{house.name}' house")
    else
      flash[:error] = "Couldn't find a user with that email."
      redirect_to house_wizard_path
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
end
