json.house do |house|
  house.id     "current"
  house.person @person.id
  house.people @roommates.map(&:id)
end

json.set! :people do
  json.array! @roommates, :partial => "people/person", :as => :person, :locals => { :current_person => @person }
end
