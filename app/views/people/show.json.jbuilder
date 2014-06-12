json.person do |person|
  person.partial! "people/person", :person => @person, :current_person => @current_person
end
