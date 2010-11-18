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
  
  validates_presence_of :name
  validate :amount_greater_than_zero
  validates_presence_of :loaner_id
  validate :at_least_one_person
  
  def add_people_associations
    people_array.each { |key, value| people << house.people.find(key) if value == "1" }
  end
  
  def send_emails
    people.each { |person| PersonMailer.new_expense_created(self, person).deliver }
  end
  
  def at_least_one_person
    errors.add(:people_array, "have to have at lease one selected.") if (people_array_count <= 0 || people_array.nil?)
  end
  
  def amount_greater_than_zero
    errors.add(:amount, 'must be greater than $0') if amount_in_cents <= 0
  end
  
  def create_debt
    people.each { |person| debts << create_expense_debt(person) }
  end
  
  protected
    def people_array_count
      (people_array.nil?) ? 0 : people_array.values.inject(0) { |count, value| count += 1 if value == "1" } 
    end
  
    def create_expense_debt(person)
      Debt.create(
        :amount_in_cents => (amount_in_cents / people.count), 
        :person_id => person.id, 
        :loaner_id => loaner_id, 
        :paid => ((loaner_id == person.id) ? true : false)
      )
    end
end
