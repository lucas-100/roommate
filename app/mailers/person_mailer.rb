class PersonMailer < ActionMailer::Base
  default :from => "Rommates Mailer Monkey <noreply@myroommateapp.com>"
  
  def new_expense_created(expense, person)
    @person = person
    @expense = expense
    @debt = expense.debts.where("person_id = ?", person.id).first
    mail(:to => @person.email,  :subject => "[MyRoommate] New expense: #{@expense.name}") 
  end
  
  def new_payment_sent(payment, person)
    @person = person
    @payment = payment
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment sent to #{@payment.person_paid.name}")
  end
  
  def new_payment_received(payment, person)
    @person = person
    @payment = payment
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment received from #{@payment.person_paying.name}")
  end
  
  def new_person_created(person, pass)
    @person = person
    @pass = pass
    mail(:to => @person.email,  :subject => "[MyRoommate] New account created for you")
  end
end
