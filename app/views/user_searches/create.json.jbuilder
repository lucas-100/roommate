json.userSearch do |search|
  search.email  @email
  search.person @person.try(:id)
  search.house  @house.try(:id)
end
