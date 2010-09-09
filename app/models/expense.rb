class Expense < ActiveRecord::Base
  belongs_to :house
  has_many :debts, :dependent => :destroy
  belongs_to :creator, :class_name => "Person", :foreign_key => :creator_id
  belongs_to :payer, :class_name => "Person", :foreign_key => :payer_id
  
  attr_accessor :people
  attr_accessor :loaner_id
  
  money :amount
  
  after_create :create_debt
  def create_debt
    people.each do |key, value|
      unless value == "1"
        people.delete(key)
      end
    end
    
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
    
    people.each do |key, value|
      unless value == "1"
        people.delete(key)
      end
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
