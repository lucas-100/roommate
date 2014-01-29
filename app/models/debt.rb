# represents an amount of money one person owes another.  a utility class simply describing the relationship of the debt.

class Debt < ActiveRecord::Base
  belongs_to :expense
  belongs_to :person
  belongs_to :loaner, :class_name => "Person"

  monetize :amount_in_cents, :as => "amount"
end
