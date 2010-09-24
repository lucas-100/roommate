desc "Get the loaner ID and people on an expense and save them to the DB"

namespace :expense do 
  task(:update_format => :environment) do
    
    Expense.all.each do |e|

      if e.loaner_id.nil?
        e.loaner_id = e.debts.first.loaner_id
      end

      if e.people.nil?
        people = {}
        e.debts.each do |d|
          people["#{d.person_id}"] = "1"
        end

        e.house.people.each do |p|
          unless people.include?("#{p.id}")
            people["#{p.id}"] = "0"
          end
        end

        e.people = people
      end

      puts "#{e.save} -- #{e.name}"
    end 
    
  end
  
  task(:update_relationships => :environment) do
    Expense.all.each do |e|
      e.person_array.each do |key, value|
        if value == "0"
          e.person_array.delete(key)
        end
      end
      
      e.person_array.keys.each do |person_id|
        e.people << Person.find(person_id)
      end
    end
  end
  
end