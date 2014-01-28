# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
    @person_session = PersonSession.new
  end

  def create
    @person_session = PersonSession.new(params[:person_session])
    if @person_session.save
      redirect_to dashboard_path, :notice => "Welcome back, #{current_person.name}"
    else
      note_failed_signin
      render :action => 'new'
    end
  end

  def destroy
    current_person_session.destroy
    redirect_to login_path, :notice => "You have been logged out."
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
