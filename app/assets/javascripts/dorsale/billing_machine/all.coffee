//= require_tree .

accounting.settings =
  currency:
    symbol : "€"   # default currency symbol is '$'
    format: "%v%s" # controls output: %s = symbol, %v = value/number (can be object: see below)
    decimal : ","  # decimal point separator
    thousand: "."  # thousands separator
    precision : 2   # decimal places

  number:
    precision : 2  # default precision on numbers is 0
    thousand: "."
    decimal : ","

window.display_euros = (amount, target) ->
  if isNaN amount
    target.text('Saisie invalide')
  else
    target.text(accounting.formatMoney(amount))
