class Payment < ActiveRecord::Base
  belongs_to :person_paid, :class_name => "Person"
  belongs_to :person_paying, :class_name => "Person"
  
  money :amount
  
  validate :amount_greater_than_zero
  validates_presence_of :person_paid_id
  
  def amount_greater_than_zero
    if amount_in_cents <= 0
      errors.add(:amount, 'must be greater than $0')
    end
  end
  
end
