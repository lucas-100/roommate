class DashboardController < ApplicationController
  before_filter :login_required
  before_filter :check_for_house
  
  respond_to :json
  respond_to :html
  
  def index 
    @house = House.includes(:people).find(current_person.house_id)
    @person = Person.includes(:expenses, :debts).find(current_person)
  end
  
  protected
    def check_for_house
      redirect_to house_wizard_path if current_person.house_id.nil?
    end
end