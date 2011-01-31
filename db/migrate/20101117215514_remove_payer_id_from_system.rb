class RemovePayerIdFromSystem < ActiveRecord::Migration
  def self.up
    remove_column :expenses, :payer_id
  end

  def self.down
    add_column :expenses, :payer_id, :integer
  end
end
