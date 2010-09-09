class AddUserToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :creator_id, :integer
    add_column :expenses, :payer_id, :integer
  end

  def self.down
    remove_column :expenses, :creator_id
    remove_column :expenses, :payer_id
  end
end
