class PersonMailer < ActionMailer::Base
  default :from => "Rommates Mailer Monkey <noreply@myroommateapp.com>"
  
  def new_expense_created(expense, person)
    @person = person
    @expense = expense
    mail(:to => @person.email,  :subject => "[MyRoommate] New expense") 
  end
  
  def new_payment_sent(payment, person)
    @person = person
    @payment = payment
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment sent")
  end
  
  def new_payment_received(payment, person)
    @person = person
    @payment = payment
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment received")
  end
  
  def new_person_created(person, pass)
    @person = person
    @pass = pass
    mail(:to => @person.email,  :subject => "[MyRoommate] New account created for you")
  end
end
