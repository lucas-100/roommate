class PagesController < ApplicationController
  before_filter :redirect_if_logged_in
  
  
  def home
    @person = Person.new
  end
  
  private
    def redirect_if_logged_in
      unless current_person.nil?
        redirect_to dashboard_path
      end
    end
  
end
