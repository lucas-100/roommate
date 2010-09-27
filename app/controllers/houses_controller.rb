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
    @house = House.new(params[:house])

    respond_to do |format|
      if @house.save
        format.html { redirect_to(@house, :notice => 'House was successfully created.') }
        format.xml  { render :xml => @house, :status => :created, :location => @house }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @house.errors, :status => :unprocessable_entity }
      end
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
