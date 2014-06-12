json.house do |house|
  house.id     @id
  house.person @person.id
  house.people @roommates.map(&:id)
  house.name   @house.name
end

json.set! :people do
  json.array! @roommates, :partial => "people/person", :as => :person, :current_person => @person
end
