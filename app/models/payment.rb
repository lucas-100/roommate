class Payment < ActiveRecord::Base
  belongs_to :person_paid, :class_name => "Person"
  belongs_to :person_paying, :class_name => "Person"
  
  money :amount
end
