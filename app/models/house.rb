# House is the unifying class for each group of people.

class House < ActiveRecord::Base
  has_many :people
  has_many :expenses
  has_many :payments
  
  def expenseless?
    (expenses.count > 0) ? false : true
  end
  
  def paymentless?
    (payments.count > 0) ? false : true
  end
  
  def roommateless?
    (people.count > 1) ? false : true
  end
end
