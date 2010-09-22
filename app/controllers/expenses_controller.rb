class ExpensesController < ApplicationController
  respond_to :json
  respond_to :html
  
  # GET /expenses
  # GET /expenses.xml
  def index
    @expenses = Expense.where("house_id = ?", current_person.house_id).order("created_at DESC").all
    
    respond_with(@expenses)
  end

  # GET /expenses/1
  # GET /expenses/1.xml
  def show
    @expense = Expense.includes(:house).find(params[:id])
    @house = @expense.house

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.xml
  def new
    @house = House.includes(:people).find(current_person.house_id)
    @expense = @house.expenses.new(:people => {})
    @people = @house.people

    respond_with(@house, @expense)
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.includes(:house).find(params[:id])
    @house = @expense.house
    @people = Person.where(:house_id => @house.id).all
  end

  # POST /expenses
  # POST /expenses.xml
  def create
    @house = House.includes(:people).find(current_person.house_id)
    @expense = @house.expenses.new(params[:expense])
    @expense.creator = current_person
    @expense.payer_id = params[:expense][:loaner_id]
    @people = @house.people

    respond_to do |format|
      if @expense.save
        
        params[:expense][:people].keys.each do |person_id|
          person = Person.find(person_id)
          PersonMailer.new_expense_created(@expense, person).deliver
        end
        
        format.html { redirect_to(root_path, :notice => 'Expense was successfully created.') }
        format.xml  { render :xml => @expense, :status => :created, :location => @expense }
      else
        flash[:error] = "Unable to save new expense."
        format.html { render :action => "new" }
        format.xml  { render :xml => @expense.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.xml
  def update
    @expense = Expense.find(params[:id])

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
    @expense = Expense.includes(:house).find(params[:id])
    @house = @expense.house
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to(root_path, :notice => "Expense was deleted.") }
      format.xml  { head :ok }
    end
  end
end
