Roommate.House = DS.Model.extend
  person:   DS.belongsTo 'person'
  people:   DS.hasMany   'person'
  #expenses: DS.hasMany 'expense'