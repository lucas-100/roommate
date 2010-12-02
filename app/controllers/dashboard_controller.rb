class DashboardController < ApplicationController
  before_filter :login_required
  
  respond_to :json
  respond_to :html
  
  def index 
    @house = House.includes(:people).find(current_person.house_id)
    @person = Person.includes(:expenses, :debts).find(current_person)
  end
end