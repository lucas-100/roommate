class CreateHasAndBelongsToTableForExpenseAndPepole < ActiveRecord::Migration
  def self.up
    create_table :expenses_people, :id => false do |t|
      t.integer :expense_id
      t.integer :person_id
    end
    
    rename_column :expenses, :people, :people_array
  end

  def self.down
    drop_table :expenses_people
    
    rename_column :expenses, :people_array, :people
  end
end
