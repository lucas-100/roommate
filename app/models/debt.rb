class Debt < ActiveRecord::Base
  belongs_to :expense
  belongs_to :person
  belongs_to :loaner, :class_name => "Person"
end
