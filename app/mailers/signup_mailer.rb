class SignupMailer < ActionMailer::Base
  default :from => "Rommates Mailer Monkey <noreply@myroommateapp.com>"
  
  def new_signup(signup)
    @signup = signup
    mail(:to => signup.email, :subject => "[MyRoommate] Thanks for signing up!")
  end
  
end
