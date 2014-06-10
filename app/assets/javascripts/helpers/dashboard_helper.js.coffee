MONEY_FORMAT =
  format: "#,###.00", locale: 'us'

Ember.Handlebars.helper 'money', (money) ->

  amount  = if money.fractional? then money.fractional else money
  amount  = if amount < 0 then amount * -1 else amount

  console.log money

  if money.currency?
    divisor = if money.currency?   then money.currency.subunit_to_unit else 100
    number = "$#{$.formatNumber(parseInt(amount) / divisor, MONEY_FORMAT)}"

    unless money.currency.thousands_separator == ","
      number = number.replace ',', money.currency.thousands_separator

    unless money.currency.decimal_mark == "."
      number = number.replace '.', money.currency.decimal_mark

  else
    number = "$#{money}"

  number
