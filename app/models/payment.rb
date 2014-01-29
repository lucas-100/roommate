# Payment is the opposite of a debt, made from one person to another

class Payment < ActiveRecord::Base
  belongs_to :person_paid, :class_name => "Person"
  belongs_to :person_paying, :class_name => "Person"
  belongs_to :house

  monetize :amount_in_cents, :as => "amount"

  validate :amount_greater_than_zero
  validates_presence_of :person_paid_id

  def amount_greater_than_zero
    if amount_in_cents <= 0
      errors.add(:amount, 'must be greater than $0')
    end
  end

end
