class PersonMailer < ActionMailer::Base
  default :from => "mailermonkey@myroommateapp.com"
  
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
end
