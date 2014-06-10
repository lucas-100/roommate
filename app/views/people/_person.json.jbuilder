json.id        person.id
json.name      person.name
json.isNewUser person.new_user?

if current_person != person
  json.balance person.total_debt_loaned(current_person)
end
