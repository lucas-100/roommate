class Expense < ActiveRecord::Base
  belongs_to :house
  has_many :debts, :dependent => :destroy
  belongs_to :creator, :class_name => "Person", :foreign_key => :creator_id
  belongs_to :loaner, :class_name => "Person", :foreign_key => :loaner_id
  serialize :people_array
  
  has_and_belongs_to_many :people
  
  money :amount
  
  before_save :add_people_associations
  after_create :create_debt
  after_save :send_emails
  # after_update :update_debt
  
  validates_presence_of :name
  validate :amount_greater_than_zero
  validates_presence_of :loaner_id
  validate :at_least_one_person
  
  def add_people_associations
    people_array.each do |key, value|
      if value == "1"
        people << house.people.find(key) unless house.people.find(key).nil?
      end
    end
  end
  
  def send_emails
    people.each do |person|
      PersonMailer.new_expense_created(self, person).deliver
    end
  end
  
  def at_least_one_person
    count = 0
    unless people_array.nil?
      people_array.each do |key, value|
        if (value == "1")
          count += 1
        end
      end
    end
    
    if count <= 0 || people_array.nil?
      errors.add(:people_array, "have to have at lease one selected.")
    end
  end
  
  def amount_greater_than_zero
    errors.add(:amount, 'must be greater than $0') if amount_in_cents <= 0
  end
  
  def create_debt
    people.each do |p|
      debts << Debt.create(
        :amount_in_cents => (amount_in_cents / people.count), 
        :person_id => p.id, 
        :loaner_id => loaner_id, 
        :paid => ((loaner_id == p.id) ? true : false)
      )
    end
  end
  
  def update_debt
    # first destroy all the old debt, they're no longer valid
    debts.each do |d|
      d.destroy
    end
    
    # now recreate all the debt with the new info
    people.each do |p|
      debts << Debt.create(
        :amount_in_cents => (amount_in_cents / people.count), 
        :person_id => p.id, 
        :loaner_id => loaner_id, 
        :paid => ((loaner_id == p.id) ? true : false)
      )
    end
  end
end
