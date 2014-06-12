Roommate.UserSearch = DS.Model.extend
  email:  DS.attr()
  person: DS.belongsTo 'person'
  house:  DS.belongsTo 'house'
