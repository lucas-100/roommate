class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :debts, :person_id
    add_index :debts, :loaner_id
    add_index :debts, :expense_id
    
    add_index :expenses, :house_id
    add_index :expenses, :creator_id
    add_index :expenses, :loaner_id
    
    add_index :expenses_people, :expense_id
    add_index :expenses_people, :person_id
    
    add_index :payments, "person_paid_id"
    add_index :payments, "person_paying_id"
    
    add_index :people, :house_id
  end                    

  def self.down
    remove_index :debts, :person_id
    remove_index :debts, :loaner_id
    remove_index :debts, :expense_id
    
    remove_index :expenses, :house_id
    remove_index :expenses, :creator_id
    remove_index :expenses, :loaner_id
    
    remove_index :expenses_people, :expense_id
    remove_index :expenses_people, :person_id
    
    remove_index :payments, "person_paid_id"
    remove_index :payments, "person_paying_id"
    
    remove_index :people, :house_id
  end
end
