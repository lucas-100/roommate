# House is the unifying class for each group of people.

class House < ActiveRecord::Base
  has_many :people
  has_many :expenses
end
