class RemovePaidAndPeopleArrayFromExpense < ActiveRecord::Migration
  def self.up
    #remove_column :expenses, :paid
    remove_column :expenses, :people_array
  end

  def self.down
    add_column :expenses, :paid, :boolean
    add_column :expenses, :people_array, :string
  end
end
