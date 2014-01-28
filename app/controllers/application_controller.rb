class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method            :current_person_session, :current_person
  
  private
  def person_required
    redirect_to login_path unless current_person.present?
  end

  def load_person
    @person ||= current_person
  end
  
  def load_house
    @house ||= current_person.house
  end

  def current_person_session
    @current_person_session ||= PersonSession.find
  end

  def current_person
    @current_person ||= current_person_session.try(:person)
  end

  def redirect_back_or_default(default = root_url, options)
    redirect_to(session.delete(:return_to) || request.referer || default, options)
  end
end
