class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthenticatedSystem
  
  protected
  def load_person
    @person ||= current_person
  end
  
  def load_house
    @house ||= current_person.house
  end
end
