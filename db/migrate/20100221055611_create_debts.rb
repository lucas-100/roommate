class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.integer :amount_in_cents
      t.integer :person_id
      t.integer :loaner_id
      t.integer :expense_id
      t.boolean :paid, :deault => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
