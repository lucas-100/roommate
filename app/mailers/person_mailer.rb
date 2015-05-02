class PersonMailer < ActionMailer::Base
  default :from => "Roommates Mailer Monkey <noreply@myroommateapp.com>"

  def new_expense_created(expense, person)
    @person = person
    @expense = expense
    @debt = expense.debts.where("person_id = ?", person.id).first
    @creator = @expense.creator
    @loaner = @expense.loaner
    mail(:to => @person.email,  :subject => "[MyRoommate] New expense: #{@expense.name}") 
  end

  def new_payment_sent(payment, person)
    @person = person
    @payment = payment
    @person_paid = @payment.person_paid
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment sent to #{@person_paid.name}")
  end

  def new_payment_received(payment, person)
    @person = person
    @payment = payment
    @person_paying = @payment.person_paying
    mail(:to => @person.email,  :subject => "[MyRoommate] New payment received from #{@person_paying.name}")
  end

  def new_person_created(person, pass)
    @person = person
    @pass = pass
    mail(:to => @person.email,  :subject => "[MyRoommate] New account created for you")
  end
end
