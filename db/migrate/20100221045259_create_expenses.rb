class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.integer :amount_in_cents
      t.integer :house_id
      t.string  :name
      t.text    :description

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
