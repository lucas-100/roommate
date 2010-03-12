class House < ActiveRecord::Base
  has_many :people
  has_many :expenses
end
