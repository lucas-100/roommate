json.person do |person|
  json.partial! "people/person", :person => @person, :current_person => @current_person
end
