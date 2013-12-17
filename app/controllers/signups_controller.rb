class SignupsController < ApplicationController

  respond_to :html

  def new
    @signup = Signup.new
    @person = Person.new
  end

  def create
    @signup = Signup.create(params[:signup])

    if @signup.save
      SignupMailer.new_signup(@signup).deliver
      render(:action => :thank_you, :notice => "Thanks for signing up!")
    else
      flash[:error] = "We couldn't sign you up."
      render( :action => :new, :notice => "We couldn't sign you up.")
    end
  end

  def thank_you
  end
end
