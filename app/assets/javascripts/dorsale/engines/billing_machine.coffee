@BillingMachine = {}

BillingMachine.settings =
  precision : 2
  thousand  : " " # nbsp
  decimal   : ","

BillingMachine.str2num = (str) ->
  parseFloat(
    String(str)
      .replace(",", ".")
      .replace(/[^-0-9\.]+/g, "")
  ) || 0.0

BillingMachine.num2str = (num) ->
  num = parseFloat(num)
  settings = BillingMachine.settings
  accounting.formatNumber(num, settings.precision, settings.thousand, settings.decimal)

BillingMachine.round2 = (num) ->
  return +(Math.round(num + "e+2")  + "e-2")

BillingMachine.updateTotals = ->
  total_excluding_taxes = 0.0

  # Update line totals
  $("#billing_machine-form .line").map ->
    return if parseInt($(this).find("input[name*=destroy]").val()) == 1
    quantity   = BillingMachine.str2num $(this).find(".line-quantity input").val()
    unit_price = BillingMachine.str2num $(this).find(".line-unit_price input").val()
    line_total = BillingMachine.round2(unit_price * quantity)
    $(this).find(".line-total input").val BillingMachine.num2str line_total

    total_excluding_taxes += line_total

  # Substract discount to total excluding taxes
  commercial_discount   = BillingMachine.str2num $(".commercial_discount input").val()
  raw_total_excluding_taxes = total_excluding_taxes
  total_excluding_taxes = raw_total_excluding_taxes - commercial_discount
  $(".total_excluding_taxes input").val BillingMachine.num2str total_excluding_taxes

  discount_rate = commercial_discount / raw_total_excluding_taxes

  # VAT amount based on each line total with discount rate
  vat_amount = 0.0
  $("#billing_machine-form .line").map ->
    return if parseInt($(this).find("input[name*=destroy]").val()) == 1

    # Per line VAT rate
    if $(this).find(".line-vat_rate input").length > 0
      vat_rate = BillingMachine.str2num $(this).find(".line-vat_rate input").val()
    # Global VAT rate
    else
      vat_rate = BillingMachine.str2num $("#totals-table .vat_rate input").val()

    line_total = BillingMachine.str2num $(this).find(".line-total input").val()
    discounted_line_total = line_total - (line_total * discount_rate)
    line_vat_amount = BillingMachine.round2(discounted_line_total * vat_rate / 100)
    vat_amount += line_vat_amount
  $(".vat_amount input").val BillingMachine.num2str vat_amount

  total_including_taxes = total_excluding_taxes + vat_amount
  $(".total_including_taxes input").val BillingMachine.num2str total_including_taxes

  # Advances is for invoices only, not for quotations
  if $(".advance input").length > 0 && $(".balance input").length > 0
    advance = BillingMachine.str2num $(".advance input").val()
    balance = total_including_taxes - advance
    $(".balance input").val BillingMachine.num2str balance

BillingMachine.formatInputs = ->
  $("#billing_machine-form input.number").map ->
    formatted_number = BillingMachine.num2str BillingMachine.str2num $(this).val()
    $(this).val formatted_number

# Empty number inputs on focus if value is 0
$(document).on "focus", "#billing_machine-form input.number", ->
  $(this).val("") if BillingMachine.str2num($(this).val()) == 0

# Auto ajust line label textarea height
$(document).on "keyup", "#billing_machine-form textarea", ->
   this.rows = this.value.split("\n").length
$("#billing_machine-form textarea").keyup()

# Button to delete line
$(document).on "click", "#billing_machine-form a.delete", (e) ->
  e.preventDefault()
  $(this).parents("td").find("input").val(1)
  $(this).parents("tr").hide()
  BillingMachine.updateTotals()

$(document).on "turbolinks:load cocoon:after-insert", ->
  BillingMachine.formatInputs()
  BillingMachine.updateTotals()

  # Fix Cocoon bug
  $("#billing_machine-form .line textarea").map ->
    this.value = this.value.trim()

$(document).on "keyup", "#billing_machine-form input.number", ->
  BillingMachine.updateTotals()

$(document).on "blur", "#billing_machine-form input.number", ->
  BillingMachine.formatInputs()
