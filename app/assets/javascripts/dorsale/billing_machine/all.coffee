//= require_tree .

accounting.settings =
  number:
    precision : 2
    thousand: " "
    decimal : ","

window.str2num = (str) ->
  parseFloat(String(str).replace(",", ".").replace(" ", "")) || 0.0

window.num2str = (num) ->
  num = parseFloat(num)
  accounting.formatNumber(num)

$(document).on "ready page:load cocoon:after-insert", ->
  $("#invoice-form input.number").keyup ->
    total_excluding_taxes = 0.0

    # Update line totals
    $("#invoice-form .invoice_line").map ->
      quantity   = str2num $(this).find(".invoice_line-quantity input").val()
      unit_price = str2num $(this).find(".invoice_line-unit_price input").val()
      line_total = unit_price * quantity
      $(this).find(".invoice_line-total input").val num2str line_total

      total_excluding_taxes += line_total

    # Substract discount to total excluding taxes
    commercial_discount   = str2num $("#invoice_commercial_discount").val()
    raw_total_excluding_taxes = total_excluding_taxes
    total_excluding_taxes = raw_total_excluding_taxes - commercial_discount
    $("#invoice_total_excluding_taxes").val num2str total_excluding_taxes

    # Per line tax rate
    if $(this).find(".invoice_line-vat_rate input").length > 0
      vat_rate = str2num $(this).find(".invoice_line-vat_rate input").val()
    # Global tax rate
    else
      vat_rate = str2num $("#invoice_vat_rate").val()

    discount_rate = commercial_discount / raw_total_excluding_taxes

    # VAT amount based on each line total with discount rate
    vat_amount = 0.0
    $("#invoice-form .invoice_line").map ->
      line_total = str2num $(this).find(".invoice_line-total input").val()
      discounted_line_total = line_total - (line_total * discount_rate)
      line_vat_amount = discounted_line_total * vat_rate / 100
      vat_amount += line_vat_amount
    $("#invoice_vat_amount").val num2str vat_amount

    total_including_taxes = total_excluding_taxes + vat_amount
    $("#invoice_total_including_taxes").val num2str total_including_taxes

    # Advances is for invoices only, not for quotations
    if $("#invoice_advance").length > 0 && $("#invoice_balance").length > 0
      advance = str2num $("#invoice_advance").val()
      balance = total_including_taxes - advance
      $("#invoice_balance").val num2str balance

  # Update amount on page load
  $("#invoice-form input").keyup()

  # Format all input correctly
  $("#invoice-form input.number").blur ->
    $("#invoice-form input.number").map ->
      formatted_number = num2str str2num $(this).val()
      $(this).val formatted_number
  $("#invoice-form input.number").blur()
