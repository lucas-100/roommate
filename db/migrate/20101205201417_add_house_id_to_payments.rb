class AddHouseIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :house_id, :integer
    
    Payment.all.each do |p|
      p.update_attribute(:house_id, p.person_paying.house.id)
    end
  end

  def self.down
    remove_column :payments, :house_id
  end
end
