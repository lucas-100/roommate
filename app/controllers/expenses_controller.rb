class ExpensesController < ApplicationController
  before_filter :login_required
  before_filter :load_person
  before_filter :load_house
  before_filter :find_expense, :only => [:update, :destroy, :show, :edit]

  respond_to :json
  respond_to :html

  # GET /expenses
  # GET /expenses.xml
  def index
    @expenses = @person.expenses.includes(:people).order("created_at DESC").all

    respond_with(@expenses)
  end

  # GET /expenses/1
  # GET /expenses/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.xml
  def new
    @expense = Expense.new
    @people = @house.people

    respond_with(@house, @expense, @people)
  end

  # GET /expenses/1/edit
  def edit
    @people = Person.where(:house_id => @house.id).all
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    @expense = Expense.new(params[:expense])

    respond_to do |format|
      if @expense.save
        format.html { redirect_to(dashboard_path, :notice => 'Expense was successfully created.') }
        format.xml  { render :xml => @expense, :status => :created, :location => @expense }
      else
        @people = @house.people
        flash[:error] = "Unable to save new expense."
        format.html { render :action => "new" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.xml
  def update
    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        format.html { redirect_to(@expense, :notice => 'Expense was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.xml
  def destroy
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to(dashboard_path(:anchor => "expenses"), :notice => "Expense was deleted.") }
      format.xml  { head :ok }
    end
  end

  protected
    def find_expense
      @expense = Expense.where(:house_id => @house.id).find(params[:id])
    end
end
