class UpdatePersonsTableForRs < ActiveRecord::Migration
  def self.up
    remove_column :people, :password
    
    add_column :people, :crypted_password,          :string, :limit => 40
    add_column :people, :salt,                      :string, :limit => 40
    add_column :people, :remember_token,            :string, :limit => 40
    add_column :people, :remember_token_expires_at, :datetime
  end

  def self.down
    add_column :people, :password, :string
    
    remove_column :people, :crypted_password         
    remove_column :people, :salt                    
    remove_column :people, :created_at              
    remove_column :people, :updated_at               
    remove_column :people, :remember_token         
    remove_column :people, :remember_token_expires_at
  end
end
