class AddingAuthlogicFieldsToPerson < ActiveRecord::Migration
  def up
    change_column :people, :crypted_password, :string, :limit => 128, :null => false, :default => ""
    change_column :people, :salt, :string, :limit => 128, :null => false, :default => ""

    change_table :people do |t|
      t.string    :persistence_token,   :null => false, :default => ""
      t.string    :perishable_token,    :null => false, :default => ""

      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
    end
  end

  def down
    change_table :people do |t|
      t.remove :persistence_token
      t.remove :perishable_token

      t.remove :login_count
      t.remove :failed_login_count
      t.remove :last_request_at
      t.remove :current_login_at
      t.remove :last_login_at
      t.remove :current_login_ip
      t.remove :last_login_ip
    end

    change_column :people, :crypted_password, :string, :limit => 40
    change_column :people, :salt, :string, :limit => 40
  end
end
