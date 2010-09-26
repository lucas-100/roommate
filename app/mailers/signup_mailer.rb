class SignupMailer < ActionMailer::Base
  default :from => "Rommates Mailer Monkey <noreply@myroommateapp.com>"
  
  def new_signup(signup)
    @signup = signup
    mail(:to => signup.email, :subject => "[MyRoommate] Thanks for signing up!")
  end
  
  def new_house_and_person(person, pass)
    @person = person
    @pass = pass
    mail(:to => @person.email, :subject => "[MyRoommate] Your account has been created")
  end
  
end
