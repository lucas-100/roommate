class DashboardController < ApplicationController
  before_filter :login_required
  
  respond_to :json
  respond_to :html
  
  def index 
    @house = House.joins(:people).find(current_person.house_id)
    @person = current_person
  end
  
  def mobile
    person = Person.find(params[:id])
    debts = person.all_debts_owed
    loans = person.all_debts_loaned
    loans_array = []
    debts_array = []
    
    debts.each do |d|
      debts_array << {:name => d[:person], :amount => d[:amount].to_s}
    end
    
    loans.each do |l|
      loans_array << {:name => l[:person], :amount => l[:amount].to_s}
    end
    
    @debts_and_loans = {:debts => debts_array, :loans => loans_array}
    
    render :layout => 'nothing'
  end
  
end