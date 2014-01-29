# The expense class keeps track of all the expenses in the database
# before saving it adds an association of people from the people array
# after saving it sends out emails and creates the debt associated with the
# expense

class Expense < ActiveRecord::Base
  belongs_to :house
  has_many :debts, :dependent => :destroy
  belongs_to :creator, :class_name => "Person", :foreign_key => :creator_id
  belongs_to :loaner, :class_name => "Person", :foreign_key => :loaner_id

  attr_accessor :people_array

  has_and_belongs_to_many :people

  monetize :amount_in_cents, :as => "amount"

  before_save :add_people_associations
  after_create :create_debt
  after_save :send_emails

  validates_presence_of :name
  validate :amount_greater_than_zero
  validates_presence_of :loaner_id
  validate :at_least_one_person

  def add_people_associations
    people_array.each { |key, value| people << Person.where(:house_id => house.id).find(key) if value == "1" }
  end

  def send_emails
    people.each { |person| PersonMailer.new_expense_created(self, person).deliver }
  end

  def at_least_one_person
    errors.add(:people_array, "have to have at lease one selected.") if ( people_array.nil? || people_array_count <= 0)
  end

  def amount_greater_than_zero
    errors.add(:amount, 'must be greater than $0') if amount_in_cents <= 0
  end

  def create_debt
    people.each { |person| debts << create_expense_debt(person) }
  end

  def who_paid
    ((creator == loaner) ? "they" : (loaner.nil?) ? "someone" : loaner.name)
  end

  protected
    def people_array_count
      people_array.values.inject(0) { |count, value| (value == "1") ? count + 1 : count }
    end

    def create_expense_debt(person)
      Debt.create(
        :amount_in_cents => (amount_in_cents / people.count),
        :person_id => person.id,
        :loaner_id => loaner_id
      )
    end
end
