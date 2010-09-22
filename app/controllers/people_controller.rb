class PeopleController < ApplicationController
  before_filter :login_required
  
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

  # GET /people/1/edit
  def edit
    @person = Person.includes(:house).find(params[:id])
    @house = @person.house
  end

  # POST /people
  # POST /people.xml
  def create
    @house = House.find(current_person.id)
    
    pass =  Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{params[:person][:email]}"))[0..7]
    if params[:person][:password] == '' || params[:person][:password].nil?
      params[:person][:password] = pass
      params[:person][:password_confirmation] = pass
    end
    
    @person = @house.people.new(params[:person])
    
    respond_to do |format|
      if @person.save
        PersonMailer.new_person_created(@person, pass).deliver
        
        format.html { redirect_to(root_path, :notice => 'Person was successfully created.') }
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
