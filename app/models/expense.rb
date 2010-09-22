class Expense < ActiveRecord::Base
  belongs_to :house
  has_many :debts, :dependent => :destroy
  belongs_to :creator, :class_name => "Person", :foreign_key => :creator_id
  belongs_to :payer, :class_name => "Person", :foreign_key => :payer_id
  belongs_to :loaner, :class_name => "Person", :foreign_key => :loaner_id
  serialize :people
  
  money :amount
  
  after_create :create_debt
  #after_update :update_debt
  
  validates_presence_of :name
  validate :amount_greater_than_zero
  validates_presence_of :loaner_id
  validate :at_least_one_person
  
  def at_least_one_person
    count = 0
    unless people.nil?
      people.each do |key, value|
        if (value == "1")
          count += 1
        end
      end
    end
    
    if count <= 0 || people.nil?
      errors.add(:people, "have to have at lease one selected.")
    end
  end
  
  def amount_greater_than_zero
    if amount_in_cents <= 0
      errors.add(:amount, 'must be greater than $0')
    end
  end
  
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
