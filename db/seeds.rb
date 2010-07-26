# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

h = House.create(:name => "3722 N. Placita Vergel")

h.people.create(:name => "Jared McFarland", :email => "jared.online@gmail.com", :password => "theshit", :password_confirmation => "theshit", :house => h)
h.people.create(:name => "Phillip McFarland", :email => "pmcfarla@email.arizona.edu", :password => "gsi103084", :password_confirmation => "gsi103084", :house => h)
h.people.create(:name => "Josh Bloemendaal", :email => "joshbloemendaal@yahoo.com", :password => "josher420", :password_confirmation => "josher420", :house => h)
h.people.create(:name => "Bill Duncan", :email => "bill.in.asia@gmail.com", :password => "unlimited", :password_confirmation => "unlimited", :house => h)