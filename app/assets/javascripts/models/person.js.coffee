Roommate.Person = DS.Model.extend
  house:   DS.belongsTo 'house'

  name:    DS.attr()
  balance: DS.attr()
