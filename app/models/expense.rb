class Expense < ActiveRecord::Base
  belongs_to :house
  has_many :debts, :dependent => :destroy
  
  attr_accessor :people
  attr_accessor :loaner_id
  
  after_create :create_debt
  def create_debt
    people.keys.each do |person_id|
      debts << Debt.create(
        :amount_in_cents => (amount_in_cents / people.count), 
        :person_id => person_id, 
        :loaner_id => loaner_id, 
        :paid => ((loaner_id == person_id) ? true : false)
      )
    end
  end
  
  after_update :update_debt
  def update_debt
    # first destroy all the old debt, they're no longer valid
    debts.each do |d|
      d.destroy
    end
    
    # now recreate all the debt with the new info
    people.keys.each do |person_id|
      debts << Debt.create(
        :amount_in_cents => (amount_in_cents / people.count),
        :person_id => person_id,
        :loaner_id => loander_id,
        :paid => ((loaner_id == person_id) ? true : false)
      )
    end
  end
end
