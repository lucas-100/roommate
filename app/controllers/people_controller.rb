class PeopleController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  
  # TODO - before_filter :load_house
  respond_to :json
  respond_to :html
  
  # GET /people
  # GET /people.xml
  def index
    house = current_person.house
    @people = []
    house.people.each do |p|
      if p != current_person
        @people << {:name => p.name}
      end
    end

    respond_with(@people)
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = current_person
    @house = @person.house
    
    respond_with(@person, @house)
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @house = House.find(current_person.house_id)
    @person = @house.people.new

    respond_with(@house, @person)
  end
  
  def signup
    
  end

  # GET /people/1/edit
  def edit
    @person = Person.includes(:house).find(params[:id])
    @house = @person.house
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    
    respond_to do |format|
      if @person.save
        self.current_person = Person.authenticate(@person.email, @person.password)
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        
        format.html { redirect_to(house_wizard_path, :notice => 'Thank you for registering! You\'ve been automatically logged in.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        flash[:error] = "Unable to create roommate."
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = current_person
    @house = @person.house

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(account_path, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        flash[:error] = "We couldn't save your profile."
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /people/1
  # PUT /people/1.xml
  def update_password
    @person = current_person
    @house = @person.house

    respond_to do |format|
      if @person.update_password(params[:person])
        format.html { redirect_to(account_path, :notice => 'Profile was successfully updated.') }
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
      current_person.update_attribute(:house_id, @person.house_id)
      redirect_to(dashboard_path, :notice => "You've been added to the '#{@person.house.name}' house")
    else
      flash[:error] = "Couldn't find a user with that email."
      redirect_to house_wizard_path
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.includes(:house).find(params[:id])
    @house = @person.house
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
end
