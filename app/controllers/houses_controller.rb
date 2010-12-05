# Controller for the House model.  Handles the HTTP requests

class HousesController < ApplicationController
  before_filter :login_required
  
  respond_to :html
  
  # GET /houses
  # GET /houses.xml
  def index
    @houses = House.all

    respond_with(@houses)
  end

  # GET /houses/1
  # GET /houses/1.xml
  def show
    # @house = House.joins(:expenses => {:debts => :loaner}).find(params[:id])
    @house = House.find(params[:id])

    respond_with(@house)
  end

  # GET /houses/new
  # GET /houses/new.xml
  def new
    @house = House.new

    respond_with(@house)
  end

  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.xml
  def create
    @house = House.new(:name => "New House")

    respond_to do |format|
      @house.save
      current_person.update_attribute(:house_id, @house.id)
      format.html { redirect_to dashboard_path, :notice => "New house created!" }
    end
  end

  # PUT /houses/1
  # PUT /houses/1.xml
  def update
    @house = House.find(params[:id])

    respond_to do |format|
      if @house.update_attributes(params[:house])
        format.html { redirect_to(root_path, :notice => 'House name changed.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.xml
  def destroy
    @house = House.find(params[:id])
    @house.destroy

    respond_to do |format|
      format.html { redirect_to(houses_url) }
      format.xml  { head :ok }
    end
  end
end
