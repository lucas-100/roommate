class AddNotesFields < ActiveRecord::Migration
  def self.up
    add_column :payments, :notes, :text
    add_column :expenses, :notes, :text
  end

  def self.down
    remove_column :payments, :notes
    remove_column :expenses, :notes
  end
end
