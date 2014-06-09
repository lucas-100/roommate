Roommate.House = DS.Model.extend
  person:    DS.belongsTo 'person'
  debtors:   DS.attr()
  debtees:   DS.attr()
