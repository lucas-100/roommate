class PersonMailer < ActionMailer::Base
  default :from => "mailermonkey@myroommatesapp.com"
  
  def new_expense_created(expense, person)
    @person = person
    @expense = expense
    mail(:to => @person.email,  :subject => "[Roommatse] New expense") 
  end
end
