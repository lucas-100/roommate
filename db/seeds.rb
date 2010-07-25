# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

House.create(:name => "3722 N. Placita Vergel")
People.create(:name => "Jared McFarland", :email => "jared.online@gmail.com", :passwword => "theshit", :password_confirmation => "theshit", :house_id => 1)