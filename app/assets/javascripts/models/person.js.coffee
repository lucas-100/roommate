DEBTOR = "debtor"
DEBTEE = "debtee"

Roommate.Person = DS.Model.extend
  house:     DS.belongsTo 'house'
  name:      DS.attr()
  balance:   DS.attr()
  isNewUser: DS.attr()

  status: (() ->
    if @get("balance")?.fractional > 0
      DEBTOR
    else if (@get("balance")?.fractional < 0)
      DEBTEE
    else
      null
  ).property("balance")

  isDebtor: (() ->
    @get("status") == DEBTOR
  ).property("status")

  isDebtee: (() ->
    @get("status") == DEBTEE
  ).property("balance", "status")
