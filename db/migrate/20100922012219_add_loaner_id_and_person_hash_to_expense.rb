class AddLoanerIdAndPersonHashToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :loaner_id, :integer
    add_column :expenses, :people, :string
  end

  def self.down
    remove_column :expenses, :loaner_id
    remove_column :expenses, :people
  end
end
