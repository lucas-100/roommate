class AddPeopleToHouse < ActiveRecord::Migration
  def self.up
    add_column :people, :house_id, :integer
  end

  def self.down
    remove_column :people, :house_id
  end
end
