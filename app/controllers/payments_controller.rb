class PaymentsController < ApplicationController
  before_filter :login_required
  before_filter :load_person
  before_filter :load_house
  
  
  respond_to :json
  respond_to :html
  
  # GET /payments
  # GET /payments.xml
  def index
    @payments_received = @person.payments_received
    @payments_made = @person.payments_made
    
    respond_with(@payments_recieved, @payments_made)
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.xml
  def new
    @payment = Payment.new
    @people = Person.where("house_id = ? AND id != ?", current_person.house_id, current_person.id).all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.xml
  def create
    @payment = Payment.new(params[:payment])
    @people = Person.where("house_id = ? AND id != ?", current_person.house_id, current_person.id).all

    respond_to do |format|
      if @payment.save
        PersonMailer.new_payment_sent(@payment, @payment.person_paying).deliver
        PersonMailer.new_payment_received(@payment, @payment.person_paid).deliver
        
        format.html { redirect_to(root_path, :notice => 'Payment was successfully created.') }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        flash[:error] = "Unabel to save payment."
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to(@payment, :notice => 'Payment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(root_path(:anchor => "payments"), :notice => "Payment was deleted.") }
      format.xml  { head :ok }
    end
  end
  
end
