class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthenticatedSystem
  
  protected
  def load_person_and_house
    @house = current_person.house
    @person = current_person
  end
end
