class DashboardController < ApplicationController
  before_filter :login_required
  
  respond_to :json
  respond_to :html
  
  def index 
    @house = House.joins(:people).find(current_person.house_id)
    @person = current_person
  end
end