class PeopleController < ApplicationController
  before_filter :login_required
  
  # TODO - before_filter :load_house
  respond_to :json
  
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
    @person = Person.includes(:house).find(params[:id])
    @house = @person.house
    
    respond_with(@person, @house)
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @house = House.find(params[:house_id])
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
    logout_keeping_session!
    @house = House.find(params[:house_id])
    @person = @house.people.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to(house_person_path(@house, @person), :notice => 'Person was successfully created.') }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.includes(:house).find(params[:id])
    @house = @person.house

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(house_person_path(@house, @person), :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
      format.html { redirect_to(house_people_url(@house)) }
      format.xml  { head :ok }
    end
  end
end
